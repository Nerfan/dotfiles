"""
Provides an easy way to change terminalrc files for xfce4-terminal.

I made this so that all of my other settings (really just the font) wouldn't change
every time I wanted to change color scheme.
Every input and output file is an xfce4-terminalrc

TODO: add support for all color options
"""

import sys

terminalrcLocation="/home/jeremy/.config/xfce4/terminal/terminalrc"

def getForeground(themeFile):
    """
    Returns the foreground color from a theme file
    """
    for line in open(themeFile):
        if line[0:16] == "ColorForeground=":
            return line[16:]


def setForeground(fgColor):
    """
    Takes a single color code for the foreground (text color) and applies it to a terminalrc file

    fgColor: String, 12-digit color code for the text color in the terminal
    """
    terminalrc = open(terminalrcLocation)
    filebefore = ""
    for line in terminalrc:
        if line[0:16] == "ColorForeground=":
            filebefore += line[0:16] + fgColor
        else:
            filebefore += line
    terminalrc.close()
    terminalrc = open(terminalrcLocation, "w")
    terminalrc.truncate()
    terminalrc.write(filebefore)
    terminalrc.close()
    print("Foreground changed")


def getBackground(themeFile):
    """
    Returns the background color from a theme file
    """
    for line in open(themeFile):
        if line[0:16] == "ColorBackground=":
            return line[16:]


def setBackground(bgColor):
    """
    Takes a single color code for the foreground (text color) and applies it to a terminalrc file

    fgColor: String, 12-digit color code for the text color in the terminal
    """
    terminalrc = open(terminalrcLocation)
    filebefore = ""
    for line in terminalrc:
        if line[0:16] == "ColorBackground=":
            filebefore += line[0:16] + bgColor
        else:
            filebefore += line
    terminalrc.close
    terminalrc = open(terminalrcLocation, "w")
    terminalrc.truncate()
    terminalrc.write(filebefore)
    terminalrc.close()
    print("Background changed")


def getColors(configFileName):
    """
    Returns a string of colors to be piped into a terminalrc file

    configFileName: String, file to draw the colrs from
    """
    config = open(configFileName)
    for line in config:
        if line[0:13] == "ColorPalette=": # Includes the ending newline character
           return line[13:]
        

def setColors(newColors):
    """
    Takes a string of color odes and replaces the colors currently set in terminalrc.
    
    newColors: String of 12-digit color codes; 16 different colors to be put in
    terminalrcLocation: Full path to the terminalrc file to be edited; unneeded argument
    """
    terminalrc = open(terminalrcLocation)
    filebefore = ""
    for line in terminalrc:
        if line[0:13] == "ColorPalette=":
            filebefore += line[0:13] + newColors
        else:
            filebefore += line
    terminalrc.close()
    terminalrc = open(terminalrcLocation, "w")
    terminalrc.truncate()
    terminalrc.write(filebefore)
    terminalrc.close()

            
def saveColors(themeName, sourceFile=terminalrcLocation):
    """
    Saves the current color configuration to a file named by the parameter

    Includes colorscheme as well as foreground and background

    themeName: String, what to call the theme
    sourceFile: String, full path to the file to draw the colors from (defaults to terminalrc)
    """
    configFile = open(themeName, "w")
    colors = getColors(sourceFile)
    configFile.write("ColorPalette=" + colors)
    configFile.write("ColorForeground=" + getForeground(sourceFile))
    configFile.write("ColorBackground=" + getBackground(sourceFile))


# Main function
if __name__=="__main__":
    if len(sys.argv) < 2:
        print("Usage: python3.5 changeColorScheme [save|load] themeFileName")
        exit(0)
    elif len(sys.argv) == 2:
        setColors(getColors(sys.argv[1]))
    elif len(sys.argv) >= 3:
        config = sys.argv[2] # The second argument will always be the name of the config
        if sys.argv[1] == "save": # If we're just saving
            saveColors(config)
        elif sys.argv[1] == "load": # Or if we're loading an existing config
            setColors(getColors(config)) # Always set the colors
            for i in range(3, len(sys.argv)): # Check for additional arguments (i.e. fg and bg)
                if sys.argv[i] == "fg":
                    setForeground(getForeground(config))
                elif sys.argv[i] == "bg":
                    setBackground(getBackground(config))


# End of file
