#!/bin/bash

###############################################################################################################
####
####                            Third party Ghidra Installer for Linux v1.0.1
####                                Copyright (c) 2024 Asanka Akash Sovis
####
#### This is a third party installer meant to setup Ghidra on Linux systems easily. It is currently written
#### to install Ghidra v11.0.3 along with Java Development Kit 23. It will install and setup the dash
#### launcher. It also supports uninstalling of a Ghidra installation.
####
#### This program is released under the MIT License <https://github.com/asankaSovis/Ghidra_Installer/blob/main/LICENSE>"
#### All other components are licensed under their own licenses.
####
#### Github Repository and further information <https://github.com/asankaSovis/Ghidra_Installer>
####
#### Created by Asanka Sovis on 14/04/2024
#### Last Edited by Asanka Sovis on 29/10/2024
####    - Upgrade to JDK 23
####
###############################################################################################################

installer_version="v1.0.1"
ghidra_version="v11.0.3"
java_version="23"

echo "Ghidra $ghidra_version Installer $installer_version"
echo "Copyright (c) 2024 Asanka Akash Sovis"
echo ""
echo "This third party script is intended to install Ghidra Reverse Engineering Suite into linux environments. It will be downloading the Java Runtime Environment and Ghidra program files from their respective repositories. For more information, use -h as arguments."
echo "This third party script is released under the MIT License. By continuing with the install, you will be agreeing to this license and the respective licenses of the third party tools used and installed."
echo ""
echo "To proceed, please press the enter key..."
read X
echo "Initializing..."

## DEFAULT PATH SETUP ----------------------------------------------------------------------------------------

install_location="$goinfre/Apps"

jdk_23_file=""
jdk_23_dir="jdk-23"
#jdk_22_link="https://download.oracle.com/java/22/latest/jdk-22_linux-x64_bin.tar.gz"
jdk_23_link="https://download.oracle.com/java/23/latest/jdk-23_linux-x64_bin.tar.gz"
jdk_23_file=${jdk_23_link##*/}

ghidra_file=""
ghidra_dir="ghidra_11.0.3_PUBLIC"
ghidra_link="https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_11.0.3_build/ghidra_11.0.3_PUBLIC_20240410.zip"
ghidra_file=${ghidra_link##*/}

ghidra_ico="https://github.com/asankaSovis/Ghidra_Installer/blob/f179df1cfeaedb541bc9c65048f69b0cb8c7ea64/icon.png"

current_dir="$(pwd)"
Desktop_file_dir="$HOME/.local/share/applications/Ghidra.desktop"

## FUNCTIONAL VARIABLES ----------------------------------------------------------------------------------------

mode=0 # Parameter mode
leave_java=0 # Leave Java install
no_open=0 # Do not open after install

## ARGUMENT PARSE ----------------------------------------------------------------------------------------------

if [ -z "$1" ] # No arguments supplied
then
    mode=0
else
    if [ -z "$2" ]
    then # Two arguments supplied

        if [[ "$1" == "-u"* ]] || [ "$1" == "--uninstall" ]
        then # Uninstall
            if [[ "$1" == *"J" ]] 
            then # Leave Java
                leave_java=1
            fi

            mode=1
        elif [ "$1" == "-x" ]
        then # Install but do not open
            mode=0
            no_open=1
        elif [ "$1" == "-h" ] || [ "$1" == "--help" ]
        then # Help
            mode=2
        elif [ "$1" == "-v" ] || [ "$1" == "--version" ]
        then # Version
            mode=3
        elif [ "$1" == "-p" ] || [ "$1" == "--parameters" ]
        then # Parameters
            mode=4
        else # Error
            mode=-1
        fi

    else # One argument supplied
        if [[ "$1" == "-i"* ]] || [ "$1" == "--install" ]
        then # Install with path
            if test -e "$2"
            then # Path provided
                if [[ "$2" == "$HOME"* ]]
                then # Path valid
                    if  [[ "$1" == *"X" ]]
                    then # Do not open
                        no_open=1
                    fi

                    mode=0
                    install_location="$2"
                else # Not a home path
                    echo "Invalid path: $2"
                    echo "Installation can only be done within the home directory."
                    exit
                fi
            else # Invalid path
                echo "Invalid path: $2"
                exit
            fi
        elif [[ "$1" == "-u"* ]] || [ "$1" == "--uninstall" ]
        then # Uninstall
            if test -e "$2"
            then # Path provided
                if [[ "$2" == "$HOME"* ]]
                then # Path valid
                    if [[ "$1" == *"J" ]]
                    then # Leave Java
                        leave_java=1
                    fi

                    mode=1
                    install_location="$2"
                else  # Not a home path
                    echo "Invalid path: $2"
                    echo "Installation can only be done within the home directory."
                    exit
                fi
            else # Invalid path
                echo "Invalid path: $2"
                exit
            fi
        else
            mode=-1
        fi
    fi
fi

## EXECUTIONS --------------------------------------------------------------------------------------------------

if [ "$mode" == 0 ]
then
    # INSTALLATION MODE ------------------------------------------------------------------------

    if [ "$jdk_23_file" == "" ]
    then
        echo "Critical error! 'jdk_23_file' variable empty. Cannot proceed with the installation."
        exit
    fi

    if [ "$ghidra_file" == "" ]
    then
        echo "Critical error! 'ghidra_file' variable empty. Cannot proceed with the installation."
        exit
    fi

    # -----------------------------------------------------------------------------------------
    # Install location handling

    echo "[1/10] Creating install location..."

    if ! test -e "$install_location"
    then
        mkdir $install_location
    fi

    cd $install_location

    # -----------------------------------------------------------------------------------------
    # JDK installing

    if ! test -e "$jdk_23_dir"
    then
        if ! test -e "$jdk_23_file"
        then
            echo "[2/10] Downloading the Java Runtime Environment..."
            echo $(wget "$jdk_23_link") > /dev/null
        else
            echo "[2/10] Java Runtime Environment installation files exist. Will reuse this file..."
        fi

        if ! test -e "$jdk_23_file"
        then
            echo "Failed to download the Java Runtime Environment! Please check your internet connection."
            exit
        fi
    else
        echo "Critical error. The Java installation already exist. Please attempt to uninstall first. Use -h for uninstall options."
        exit
    fi

    # -----------------------------------------------------------------------------------------
    # Ghidra installing

    if ! test -e "$ghidra_dir"
    then
        if ! test -e "$ghidra_file"
        then
            echo "[3/10] Downloading the Ghidra installation files..."
            echo $(wget "$ghidra_link") > /dev/null
        else
            echo "[3/10] Ghidra installation files exist. Will reuse this file..."
        fi

        if ! test -e "$ghidra_file"
        then
            echo "Failed to download the Ghidra installation files! Please check your internet connection."
            exit
        fi
    else
        echo "Critical error. The Ghidra installation already exist. Please attempt to uninstall first. Use -h for uninstall options."
        exit
    fi

    # -----------------------------------------------------------------------------------------
    # JDK Extracting

    rm -rf "$jdk_23_dir"

    if ! test -e "$jdk_23_dir"
    then
        echo "[4/10] Extracting the Java Runtime Environment..."
        echo $(tar xvzf $jdk_23_file --overwrite) > /dev/null
    fi

    # -----------------------------------------------------------------------------------------
    # Ghidra Extracting

    rm -rf "$ghidra_dir"

    if ! test -e "$ghidra_dir"
    then
        echo "[5/10] Extracting  the Ghidra installation files..."
        echo $(unzip -o $ghidra_file) > /dev/null
    fi

    # -----------------------------------------------------------------------------------------
    # Validating the install

    echo "[6/10] Validating..."

    ghidra_done=0
    jdk_done=0

    for entry in "$install_location"/*
    do
        if [[ "$entry" == *"jdk"* ]] && [[ "$entry" != *".tar.gz" ]]
        then
            jdk_23_dir="$entry"
            jdk_done=1
        fi
        
        if [[ "$entry" == *"ghidra"* ]] && [[ "$entry" != *".zip" ]]
        then
            ghidra_dir="$entry"
            ghidra_done=1
        fi
    done

    if [ $jdk_done == 0 ]
    then
        echo "Failed to extract the Java Runtime Environment! Please check your priviledge level."
    fi

    if [ $ghidra_done == 0 ]
    then
        echo "Failed to extract the Ghidra installation files! Please check your priviledge level."
    fi

    # -----------------------------------------------------------------------------------------
    # Creating the run file for Ghidra launching

    echo "[7/10] Creating run file..."

    touch $ghidra_dir/appRun
    echo "#!/bin/bash

    export PATH=$jdk_23_dir/bin:\$PATH
    setsid ./ghidraRun &
    sleep 5" > $ghidra_dir/appRun
    chmod +x $ghidra_dir/appRun

    # -----------------------------------------------------------------------------------------
    # Copying the icon file

    echo "[8/10] Copying icon..."

    if test -e "$current_dir/icon.png"
    then
        cp "$current_dir/icon.png" $ghidra_dir
    else
        echo $(wget "$ghidra_ico") > /dev/null
        cp "icon.png" $ghidra_dir
    fi

    # -----------------------------------------------------------------------------------------
    # Creating the desktop file

    echo "[9/10] Creating the dash launcher..."

    touch $Desktop_file_dir
    echo "[Desktop Entry]
    Categories=Application;Development;
    Comment[en_US]=Ghidra Software Reverse Engineering Suite
    Comment=Ghidra Software Reverse Engineering Suite
    Exec=$ghidra_dir/appRun
    GenericName[en_US]=Ghidra Software Reverse Engineering Suite
    GenericName=Ghidra Software Reverse Engineering Suite
    Icon=$ghidra_dir/icon.png
    MimeType=
    Name[en_US]=Ghidra
    Name=Ghidra
    Path=$ghidra_dir/
    StartupNotify=false
    Terminal=false
    TerminalOptions=
    Type=Application
    Version=1.0
    X-DBUS-ServiceName=
    X-DBUS-StartupType=none
    X-KDE-SubstituteUID=false
    X-KDE-Username=
    " > $Desktop_file_dir
    chmod +x $Desktop_file_dir

    # -----------------------------------------------------------------------------------------
    # Deleting the Zip files

    echo "[10/10] Cleaning up..."

    $(rm -f $jdk_23_file $ghidra_file wget-log) > /dev/null

    # -----------------------------------------------------------------------------------------
    # Completion

    echo ""
    echo "Installation complete. Ghidra is now installed in your computer! Remember, you can run this script with the -u argument to uninstall Ghidra and all of the installed files."
    echo ""
    echo "Press the enter key to exit..."
    read X

    if [ "$no_open" == 0 ]
    then
        cd $ghidra_dir
        setsid ./appRun &
        sleep 5
    fi

elif [ "$mode" == 1 ]
then
    # UNINSTALL MODE ------------------------------------------------------------------------

    # -----------------------------------------------------------------------------------------
    # Checking the install path for existing files and directories

    echo "[1/3] Looking for installed files..."

    ghidra_install_available=0
    ghidra_zip_available=0
    jdk_install_available=0
    jdk_zip_available=0
    Desktop_available=0

    if test -e "$install_location"
    then
        for entry in "$install_location"/*
        do
            if [[ "$entry" == *"jdk"* ]]
            then
                if [[ "$entry" == *".tar.gz" ]]
                then
                    jdk_23_file="$entry"
                    jdk_zip_available=1
                else
                    jdk_23_dir="$entry"
                    jdk_install_available=1
                fi
            fi

            if [[ "$entry" == *"ghidra"* ]]
            then
                if [[ "$entry" == *".zip" ]]
                then
                    ghidra_file="$entry"
                    ghidra_zip_available=1
                else
                    ghidra_dir="$entry"
                    ghidra_install_available=1
                fi
            fi
        done
    fi

    if test -e "$Desktop_file_dir"
    then
        Desktop_available=1
    fi

    if [ "$leave_java" == 1 ]
    then
        echo "Uninstaller will skip Java installation."
        jdk_install_available=0
    fi

    counter=1
    uninstall_string=""

    if [ "$ghidra_install_available" == 1 ]
    then
        uninstall_string="$uninstall_string
    [$counter] $ghidra_dir"
        counter=$((counter + 1))
    fi

    if [ "$ghidra_zip_available" == 1 ]
    then
        uninstall_string="$uninstall_string
    [$counter] $ghidra_file"
        counter=$((counter + 1))
    fi

    if [ "$jdk_install_available" == 1 ]
    then
        uninstall_string="$uninstall_string
    [$counter] $jdk_23_dir"
        counter=$((counter + 1))
    fi

    if [ "$jdk_zip_available" == 1 ]
    then
        uninstall_string="$uninstall_string
    [$counter] $jdk_23_file"
        counter=$((counter + 1))
    fi

    if [ "$Desktop_available" == 1 ]
    then
        uninstall_string="$uninstall_string
    [$counter] $Desktop_file_dir"
        counter=$((counter + 1))
    fi

    if [ "$counter" == 1 ]
    then
        echo "[2/3] No entries to remove."
        echo "[3/3] Ghidra is not installed on your computer."
        echo ""
        echo "Press the enter key to exit..."
        read X

    else
        echo ""
        echo "The following files and directories will be removed:$uninstall_string"
        echo ""
        echo "To proceed, please press the enter key or Ctrl + C to exit..."
        read X

        # -----------------------------------------------------------------------------------------
        # Removing all files and folders

        echo "[2/3] Removing entries..."

        if [ "$ghidra_install_available" == 1 ]
        then
            rm -rf $ghidra_dir
        fi

        if [ "$ghidra_zip_available" == 1 ]
        then
            rm -rf $ghidra_file
        fi

        if [ "$jdk_install_available" == 1 ]
        then
            rm -rf $jdk_23_dir
        fi

        if [ "$jdk_zip_available" == 1 ]
        then
            rm -rf $jdk_23_file
        fi

        if [ "$Desktop_available" == 1 ]
        then
            rm -rf $Desktop_file_dir
        fi

        # -----------------------------------------------------------------------------------------
        # Validating the progress


        echo "[3/3] Validating uninstall status..."

        ghidra_install_available=0
        ghidra_zip_available=0
        jdk_install_available=0
        jdk_zip_available=0
        Desktop_available=0
        uninstall_complete=1

        if test -e "$install_location"
        then
            for entry in "$install_location"/*
            do
                if [[ "$entry" == *"jdk"* ]]
                then
                    if [[ "$entry" == *".tar.gz" ]]
                    then
                        jdk_zip_available=1
                        uninstall_complete=0
                    else
                        if [ "$leave_java" == 0 ]
                        then
                            jdk_install_available=1
                            uninstall_complete=0
                        fi
                    fi
                fi

                if [[ "$entry" == *"ghidra"* ]]
                then
                    if [[ "$entry" == *".zip" ]]
                    then
                        ghidra_zip_available=1
                        uninstall_complete=0
                    else
                        ghidra_install_available=1
                        uninstall_complete=0
                    fi
                fi
            done
        fi

        if test -e "$Desktop_file_dir"
        then
            Desktop_available=1
            uninstall_complete=0
        fi

        if [ "$uninstall_complete" == 1 ]
        then
            echo ""
            echo "Uninstall complete. Ghidra is now removed from your computer!"
            echo ""
            echo "Press the enter key to exit..."
            read X
        else
            echo ""
            echo "Uninstall failed! Some files and/or directories were not removed from your computer. You can review them below:"

            counter=1

            if [ "$ghidra_install_available" == 1 ]
            then
                echo "  [$counter] $ghidra_dir"
                counter=$((counter + 1))
            fi

            if [ "$ghidra_zip_available" == 1 ]
            then
                echo "  [$counter] $ghidra_file"
                counter=$((counter + 1))
            fi

            if [ "$jdk_install_available" == 1 ]
            then
                echo "  [$counter] $jdk_23_dir"
                counter=$((counter + 1))
            fi

            if [ "$jdk_zip_available" == 1 ]
            then
                echo "  [$counter] $jdk_23_file"
                counter=$((counter + 1))
            fi

            if [ "$Desktop_available" == 1 ]
            then
                echo "  [$counter] $Desktop_file_dir"
                counter=$((counter + 1))
            fi

            echo "You can manually delete them from their respective locations."

            echo ""
            echo "Press the enter key to exit..."
            read X
        fi
    fi

elif [ "$mode" == 2 ]
then
    # HELP MODE -----------------------------------------------------------------------------

    echo "Usage: ghidra_install.sh [OPTION] [PATH]"
    echo ""
    echo "If no option is provided, the installer automatically defaults to install mode. Example:"
    echo "ghidra_install.sh"
    echo "Provide  options for any other functionality as given after the below example. Example for uninstalling:"
    echo "ghidra_install.sh -u"
    echo "Provide  options for install/uninstall as given after the below example. Example for installing with manual path:"
    echo "ghidra_install.sh -i \$HOME/MyApps"
    echo ""
    echo "Options:"
    echo "  -x                      Install Ghidra but do not open after install"
    echo "  -iX             [PATH]  Install Ghidra with manual path but do not open after install"
    echo "  -i, --install   [PATH]  Install Ghidra with manual path"
    echo "  -u, --uninstall         Uninstall Ghidra"
    echo "  -u, --uninstall [PATH]  Uninstall Ghidra with manual path"
    echo "  -uJ                     Uninstall Ghidra but leave Java"
    echo "  -uJ             [PATH]  Uninstall Ghidra with manual path but leave Java"
    echo "  -v, --version           Display version information"
    echo "  -p, --parameters        Inspect default parameters"
    echo "  -h, --help              Show help pages"
    echo ""
    echo "More information can be found in Ghidra Installer Github repository <https://github.com/asankaSovis/Ghidra_Installer>"
    echo "Read the MIT License for Ghidra Installer <https://github.com/asankaSovis/Ghidra_Installer/blob/main/LICENSE>"
    echo "Read the Apache License 2.0 for Ghidra <https://github.com/NationalSecurityAgency/ghidra/blob/master/LICENSE>"
    echo "Read the Oracle No-Fee Terms and Conditions (NFTC) for Java <https://www.oracle.com/downloads/licenses/no-fee-license.html>"
    echo "Please report bugs and suggest features <https://github.com/asankaSovis/Ghidra_Installer/issues>"
    echo "Please include the terminal output in the description."
    echo ""
    echo "Press the enter key to exit..."
    read X

elif [ "$mode" == 3 ]
then
    # VERSION MODE ------------------------------------------------------------------------

    echo "Ghidra $ghidra_version Installer $installer_version for Linux"
    echo "Copyright (c) 2024 Asanka Akash Sovis"
    echo "  Ghidra: $ghidra_version         Java: $java_version"
    echo ""
    echo "Press the enter key to exit..."
    read X

elif [ "$mode" == 4 ]
then
    # PARAMETER MODE ------------------------------------------------------------------------

    echo "Installation parameters:"
    echo "  [*] Install location:       $install_location"
    echo "  [*] Ghidra download link:   <$ghidra_link>"
    echo "  [*] Java download link:     <$ghidra_link>"
    echo ""
    echo "Press the enter key to exit..."
    read X

else
    # INVALID ARGUMENTS ------------------------------------------------------------------------

    echo "Invalid arguments provided. Please refer to -h for more information."
    echo ""
    echo "Press the enter key to exit..."
    read X

fi

## -------------------------------------------------------------------------------------------------------------
