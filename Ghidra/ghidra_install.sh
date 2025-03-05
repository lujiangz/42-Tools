#!/bin/bash

###############################################################################################################
####                            Third party Ghidra Installer for Linux v1.0.1
####                                Copyright (c) 2024 Asanka Akash Sovis
#### This program is released under the MIT License <https://github.com/asankaSovis/Ghidra_Installer/blob/main/LICENSE>
#### Github Repository <https://github.com/asankaSovis/Ghidra_Installer>
#### Created by Asanka Sovis on 14/04/2024
#### Last Edited by lujiangz on 05/03/2025
###############################################################################################################

installer_version="v1.0.1"
ghidra_version="v11.0.3"
java_version="23"

echo "Ghidra $ghidra_version Installer $installer_version"
echo "Copyright (c) 2024 Asanka Akash Sovis"
echo "To proceed, please press the enter key..."
read X
echo "Initializing..."

## DEFAULT PATH SETUP ----------------------------------------------------------------------------------------

install_location="$goinfre/Apps"
jdk_23_link="https://download.oracle.com/java/23/latest/jdk-23_linux-x64_bin.tar.gz"
jdk_23_file=${jdk_23_link##*/}
jdk_23_dir="jdk-23"
ghidra_link="https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_11.0.3_build/ghidra_11.0.3_PUBLIC_20240410.zip"
ghidra_file=${ghidra_link##*/}
ghidra_dir="ghidra_11.0.3_PUBLIC"
ghidra_ico="https://github.com/asankaSovis/Ghidra_Installer/blob/f179df1cfeaedb541bc9c65048f69b0cb8c7ea64/icon.png"
current_dir="$(pwd)"
Desktop_file_dir="$HOME/.local/share/applications/Ghidra.desktop"

## ARGUMENT PARSE ----------------------------------------------------------------------------------------------

mode=0 # Default to install

if [ -n "$1" ]
then
    if [ "$1" == "-u" ]
    then
        mode=1  # Uninstall archives
    elif [ "$1" == "-r" ]
    then
        mode=2  # Reinstall
    elif [ "$1" == "-i" ]
    then
        mode=0  # Install
    else
        echo "Invalid argument. Use: -i (install), -u (uninstall archives), -r (reinstall)"
        exit
    fi
fi

## EXECUTIONS --------------------------------------------------------------------------------------------------

if [ "$mode" == 0 ]
then
    # INSTALLATION MODE ------------------------------------------------------------------------

    echo "[1/10] Creating install location..."
    mkdir -p "$install_location"
    cd "$install_location"

    # Download and install JDK
    if ! test -e "$jdk_23_dir"
    then
        echo "[2/10] Downloading Java Runtime Environment..."
        wget "$jdk_23_link" > /dev/null 2>&1
        echo "[4/10] Extracting Java Runtime Environment..."
        tar xvzf "$jdk_23_file" --overwrite > /dev/null 2>&1
    fi

    # Download and install Ghidra
    if ! test -e "$ghidra_dir"
    then
        echo "[3/10] Downloading Ghidra installation files..."
        wget "$ghidra_link" > /dev/null 2>&1
        echo "[5/10] Extracting Ghidra installation files..."
        unzip -o "$ghidra_file" > /dev/null 2>&1
    fi

    # Validate installation
    echo "[6/10] Validating..."
    [ -d "$jdk_23_dir" ] || echo "Java installation failed!"
    [ -d "$ghidra_dir" ] || echo "Ghidra installation failed!"

    # Create run file
    echo "[7/10] Creating run file..."
    echo "#!/bin/bash
export PATH=$install_location/$jdk_23_dir/bin:\$PATH
setsid ./ghidraRun &
sleep 5" > "$ghidra_dir/appRun"
    chmod +x "$ghidra_dir/appRun"

    # Copy icon
    echo "[8/10] Copying icon..."
    [ -e "$current_dir/icon.png" ] && cp "$current_dir/icon.png" "$ghidra_dir" || wget "$ghidra_ico" -O "$ghidra_dir/icon.png" > /dev/null 2>&1

    # Create desktop file
    echo "[9/10] Creating dash launcher..."
    echo "[Desktop Entry]
Categories=Application;Development;
Comment=Ghidra Software Reverse Engineering Suite
Exec=$ghidra_dir/appRun
Icon=$ghidra_dir/icon.png
Name=Ghidra
Path=$ghidra_dir/
StartupNotify=false
Terminal=false
Type=Application" > "$Desktop_file_dir"
    chmod +x "$Desktop_file_dir"

    # Cleanup
    echo "[10/10] Cleaning up..."
    rm -f "$jdk_23_file" "$ghidra_file" wget-log

    echo "Installation complete!"
    cd "$ghidra_dir"
    setsid ./appRun &
    sleep 5

elif [ "$mode" == 1 ]
then
    # UNINSTALL ARCHIVES MODE ------------------------------------------------------------------------

    echo "[1/3] Looking for downloaded archives..."
    cd "$install_location"
    rm -f "$jdk_23_file" "$ghidra_file" wget-log
    echo "[2/3] Archives removed!"
    echo "[3/3] Cleanup complete!"

elif [ "$mode" == 2 ]
then
    # REINSTALL MODE ------------------------------------------------------------------------

    echo "[1/4] Removing existing installation..."
    cd "$install_location"
    rm -rf "$jdk_23_dir" "$ghidra_dir" "$jdk_23_file" "$ghidra_file" "$Desktop_file_dir" wget-log
    
    echo "[2/4] Starting new installation..."
    bash "$0" -i  # Recursively call with install mode
    
    echo "[3/4] Reinstallation complete!"
    echo "[4/4] Ghidra should be running..."

fi

echo "Press enter to exit..."
read X
