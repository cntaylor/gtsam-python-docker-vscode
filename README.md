# Motivation
I have a windows machine, but want to run [GTSAM](https://github.com/borglab/gtsam).  While you can build in Windows, GTSAM is realy designed to run on a Unix/Linux system, so Docker is a nice option.  However, I would like to do graphs occasionally to see results, don't want to have a new development environment, etc.  You could set up a whole VNC, etc., but VS Code allows you to run "within" the Docker so your development environment is the same as always, without requiring graphic drivers inside the Docker container.  Furthermore, VSCode will display images and such for you directly if you just put a #%% at the top of a Python file.  This makes it look like a "Jupyter" style thing, and VS Code then displays your figures.

# Structure
While using Docker, there are really 3 different things that can be done that are useful.  First, you can run your own code in VS Code and not ever jump into GTSAM.  Second, you can run your own code, but then also need to jump into GTSAM code to debug what is going on.  Third, you may want the current documentation for GTSAM to be available.  Each of these cases are covered below (in reverse order)

## GTSAM documentation
The documentation at gtsam.org is currently at version 4.0.0, while the develop is ... higher.  You can create your own documentation for the current code, but it is in a format that it really needs to be served from webserver.  Fortunately, this is very easy for docker. So...
* `docker build --target docs -t cntaylor/gtsam-doc .`

This creates a Docker image that will serve up the gtsam documentation on the local port.  To launch the container using this image, use:

`docker run -d -p 8888:80 cntaylor/gtsam-doc`

I then go to `localhost:8888` in my web browser and can happily browse the gtsam documentation.

Or you can run those two commands using `./doc_docker.sh`


## GTSAM in VS Code (release and debug)
Basically, run `new_docker.sh` or run the commands in that file.  (Requires a bash shell -- I use git bash).  The first time you run this, it takes forever, but it is downloading all sorts of packages, then compiling with the most recent GTSAM.  Note that you don't actually have to run both commands, but if you want to do both release and debug, then you need both.  You can run just one command to reduce compile times if you know you won't need the other one (release or debug).

Once this is done, you can run your code in VSCODE.

# Running your own code
* In VS Code, install the `Dev Containers` extension.  
* Copy the things inside the `to-copy` directory into the directory that has your code.  Basically, you need the `Dockerfile`, the `.devcontainer/devcontainer.json` file, and -- for debugging -- the `.vscode/launch.json` file.
* Open up a VS Code window for the directory with your code in it (may want the code to be in `\\WSL$` somewhere -- not needed but supposed to be faster)
* Call `Dev Containers: Open Folder in Container` (use ctrl-shift-P and start typing).  Use the directory with your code in it and tell it to use the `From Dockerfile` option.  Ignore all of the "additional install" options.  
* If you want to run the gtsam code itself, you can do a `Add folder to workspace` inside VScode and add `/usr/src/gtsam` to your workspace.  This is the folder with the **gtsam** code.  This enables you to (for example) run the Python examples in `/usr/src/gtsam/python/gstam/examples`.  

**Hints**
* The first time I tried to run Python code inside the container, VSCode complained that I hadn't chosen the Python interpreter.  Make sure to choose the one inside the container (e.g., /usr/bin/python3) as opposed to something in the host computer.
* For some reason, even though I copied `launch.json` into my directory, it seems to get overwritten with a blank file sometimes.  Just copy the "configurations" structure into the launch.json if things don't work to enable debugging of C++ code.

## Using "debug" mode
If you are only debugging in Python, this is not needed.  These steps allow you to debug C++ (e.g. gtsam) code while writing your high-level code in Python.

Using the `devcontainer.json` file, you can switch between debug and release.  There is a "target" property in the json file that asks for which target to build.  Set it to "debug" or "release" (default is release).  Note that this assumes you built both versions in the instructions above!  After you change it, VSCode will tell you it noticed a change in the configuration file and the container may need to be rebuilt.  Please rebuild the container!

To enable breakpoints in the C++ code, you will need to start your debugging session using the "Python Debugger: Debug using launch.json".  This uses the great extension `pythoncpp.debug` that automatically attaches a "gdb" debugger to your C++ code while launching the Python debugger.  Note that you still can't "step into" the C++ code, but you can set breakpoints in the C++ code, and it will stop there when things are being run.  It is probably worth glancing at the documentation for the pythoncpp extension as there are some intricacies in mixed debugging that it mentions.

## Go!
You can now run your Python code in the Docker container.  If you put a `#%% `at the top of your Python file, it will treat it like a Jupyter notebook and the output (including plots/graphics!) will show up inside of VScode

# (Hopefully) helpful hints
* Most functions are the same name in Python as in C (i.e. what the gtsam documentation provides)
* You can run iPython in the terminal in VSCode to help you find the function names in Python
* Often, if a function is not found in Python, it is templated in C++ and you have to put the typename after it to make it work in Python.  For example, `Values.at` become `Values.atPose2` in Python

