# Motivation
I have a windows machine, but want to run [GTSAM](https://github.com/borglab/gtsam).  While you can build in Windows, GTSAM is realy designed to run on a Unix/Linux system, so Docker is a nice option.  However, I would like to do graphs occasionally to see results, don't want to have a new development environment, etc.  You could set up a whole VNC, etc., but VS Code allows you to run "within" the Docker so your development environment is the same as always, without requiring graphic drivers inside the Docker container.  Furthermore, VSCode will display images and such for you directly if you just put a #%% at the top of a Python file.  This makes it look like a "Jupyter" style thing, and VS Code then displays your figures.

# Structure
Basically, I generate two Docker images.  The first one creates a container with all the libraries, etc. needed for GTSAM to run with Python, plus a couple that enable VSCode to display images.  The second Docker basically downloads the most recent gtsam repository and compiles it.  This allow you to quickly get your GTSAM version up to date without making a whole new "machine" (which can take a bit in Docker).

# To use
## Starting fresh
Basically, run `new_docker.sh`.  (Requires a bash shell -- I use git bash).  It is a couple of really simple scripts, so you can just run the commands if you don't have a bash shell.  The first time you run this, it takes forever, but it is downloading all sorts of packages, then compiling with the most recent GTSAM.

## Updating GTSAM
If you have done this once before, but just want the most recent version of GTSAM, run `update_gtsam.sh`.  This runs a subset of `new_docker.sh`.

## Docker is made, now what
### Running your own code
* In VS Code, install the `Remote - Containers` extension.  
* Copy the Dockerfile in the `to-copy` directory into the directory that has your code
* Open up a VS Code window for the directory with your code in it (may want the code to be in `\\WSL$` somewhere -- not needed but supposed to be faster)
* Call `Remote-Containers: Open Folder in Container` (use F1 and start typing).  Use the directory with your code in it and tell it to use the `From Dockerfile` option
* Under extensions, find the `Python` extension and install it in the Dev container

You can now run your Python code in the Docker container.  If you put a `#%% `at the top of your Python file, it will treat it like a Docker container and the output (including plots/graphics!) will show up inside of VScode

### Running examples from GTSAM
Do all the steps above to run your own code, then run `Remote-Containers: Attach to a Running Container`.  You can then open up `/usr/src/gtsam/python/gtsam/examples` and run the code that you want to.

### (Hopefully) helpful hints
* Most functions are the same name in Python as in C (i.e. what the gtsam documentation provides)
* You can run iPython in the terminal in VSCode to help you find the function names in Python
* Often, if a function is not found in Python, it is templated in C++ and you have to put the typename after it to make it work in Python.  For example, `Values.at` become `Values.atPose2` in Python

# Want better documentation
The documentation at gtsam.org is currently at version 4.0.0, while the develop is >4.1.0.  You can create your own documentation for the current code, but it is in a format that it really needs to be served from webserver.  Fortunately, this is very easy for docker. So...
* cd gtsam-doc
* docker build -t cntaylor/gtsam-doc .

This creates a Docker container that will serve up the gtsam documentation on the local port.  I use:

`docker run -d -p 8888:80 cntaylor/gtsam-doc`

I then go to `localhost:8888` in my web browser and can happily browse the gtsam documentation.