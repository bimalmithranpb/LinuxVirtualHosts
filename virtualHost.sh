#!/bin/bash

helpFunction() {
    echo ""
    echo "Usage: $0 -f fileName -d domain -p path"
    echo -e "\t-f Name of the configuration file"
    echo -e "\t-d Virtual host domain"
    echo -e "\t-p Path/Document Root of the application folder"
    exit 1 # Exit script after printing help
}

while getopts "f:d:p:" opt; do
    case "$opt" in
    f) fileName="$OPTARG" ;;
    d) domain="$OPTARG" ;;
    p) path="$OPTARG" ;;
    ?) helpFunction ;; # Print helpFunction in case parameter is non-existent
    esac
done

# Print helpFunction in case parameters are empty
if [ -z "$fileName" ] || [ -z "$domain" ] || [ -z "$path" ]; then
    echo "Some or all of the parameters are empty"
    helpFunction
fi

# Create a copy of the template file
cp template.txt temp.txt
# Search and replace domain name and document root
sed -i -e "s|{domain}|$domain|g" -e "s|{path}|$path|g" temp.txt

# Create directory if not exists
mkdir -p $path
# Copy the contents of the "temp.txt" file to the new config file.
sudo cp temp.txt /etc/apache2/sites-available/$fileName.conf

# Enable the new config file
sudo a2ensite $fileName
# Restart apache
sudo service apache2 restart

# Get SSL cetificate for the given domain
sudo certbot --apache -d $domain

# Remove the "temp.txt" file
rm temp.txt
