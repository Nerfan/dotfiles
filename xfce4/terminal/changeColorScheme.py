"""
Provides an easy way to change terminalrc files for xfce4-terminal.

I made this so that all of my other settings (really just the font) wouldn't change
every time I wanted to change color scheme.
TODO: add support for foreground and background
add support for all color options
"""

import sys

def setColors(newColors, terminalrcLocation="/home/jeremy/.config/xfce4/terminal/terminalrc"):
     """
     Takes a string of color odes and replaces the colors currently set in terminalrc.
 
     Can also take an argument for where the terminalrc is
     
     newColors: String of 12-digit color codes; 16 different colors to be put in
     terminalrcLocation: Full path to the terminalrc file to be edited; unneeded argument
     """
     terminalrc = open(terminalrcLocation)
     filebefore = ""
     for line in terminalrc:
         if line[0:13] == "ColorPalette=":
             filebefore += line[0:13] + newColors + "\n"
         else:
             filebefore += line
     terminalrc.close()
     terminalrc = open(terminalrcLocation, "w")
     terminalrc.truncate()
     terminalrc.write(filebefore)
     terminalrc.close()

def saveColors(themeName, sourceFile="/home/jeremy/.config/xfce4/terminal/terminalrc"):
    """
    Saves the current color configuration to a file named by the parameter

    themeName: String, what to call the theme
    sourceFile: String, full path to the file to draw the colors from (defaults to terminalrc)
    """
    configFile = open(themeName, "w")
    colors = getColors(sourceFile)
    configFile.write("ColorPalette=" + colors)


def getColors(configFileName):
    """
    Returns a string of colors to be piped into a terminalrc file

    configFileName: String, file to draw the colrs from
    """
    config = open(configFileName)
    for line in config:
        if line[0:13] == "ColorPalette=":
            return line[13:]

if __name__=="__main__":
    if len(sys.argv) == 2:
        setColors(getColors(sys.argv[1]))
    elif len(sys.argv) == 3:
        if sys.argv[1] == "save":
            saveColors(sys.argv[2])
        if sys.argv[1] == "load":
            setColors(getColors(sys.argv[2]))
    else:
        print("Usage: python3.5 changeColorScheme [save|load] themeFileName")
        exit(0)

