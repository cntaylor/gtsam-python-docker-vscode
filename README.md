# Motivation
I have a windows machine, but want to run [GTSAM](https://github.com/borglab/gtsam).  While you can build in Windows, GTSAM is realy designed to run on a Unix/Linux system, so Docker is a nice option.  However, I would like to do graphs occasionally to see results, don't want to have a new development environment, etc.  You could set up a whole VNC, etc., but VS Code allows you to run "within" the Docker so your development environment is the same as always, without requiring graphic drivers inside the Docker container.  Furthermore, VSCode will display images and such for you directly if you just put a #%% at the top of a Python file.  This makes it look like a "Jupyter" style thing, and VS Code then displays your figures.

# Structure
Basically, I generate two Docker images.  The first one creates a container with all the libraries, etc. needed for GTSAM to run with Python, plus a couple that enable VSCode to display images.  The second Docker basically downloads the most recent gtsam repository and compiles it.  This allow you to quickly get your GTSAM version up to date without making a whole new "machine" (which can take a bit in Docker).

# To use
## Starting fresh
Basically, run `new_docker.sh`.  I run this in git bash.  The first time you run this, it takes forever, but it is downloading all sorts of packages, the compiling with the most recent GTSAM.

## Updating GTSAM
If you have done this once before, but just want the most recent version of GTSAM, run `update_gtsam.sh`.  This runs a subset of `new_docker.sh`.

## Docker is made, now what
