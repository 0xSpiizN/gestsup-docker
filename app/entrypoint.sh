#!/usr/bin/env bash
set -euo pipefail

#--------------------------------------------------
# Variables
#--------------------------------------------------
DEST="/var/www/html"
ZIP="gestsup_${GESTSUP_VERSION}.zip"
URL="https://gestsup.fr/downloads/versions/current/version/${ZIP}"
SEC_CONF="/etc/apache2/conf-enabled/security.conf"

#--------------------------------------------------
# First install setup
#--------------------------------------------------
if [ ! -f "${DEST}/.installed" ]; then
    echo "Running first install setup..."

    #--------------------------------------------------
    # Download and extract GestSup
    #--------------------------------------------------
    echo "Downloading GestSup version ${GESTSUP_VERSION}..."
    wget -q -P "${DEST}" "${URL}"
    echo "Unzipping ${ZIP}..."
    unzip -qo "${DEST}/${ZIP}" -d "${DEST}"

    #--------------------------------------------------
    # Clean up default files
    #--------------------------------------------------
    echo "Cleaning up default files..."
    rm -f "${DEST}/${ZIP}"
    rm -f "${DEST}/index.html"

    #--------------------------------------------------
    # Setting ownership and permissions
    #--------------------------------------------------
    echo "Setting ownership and permissions..."
    chown -R www-data:www-data "${DEST}"
    find "${DEST}" -type d -exec chmod 750 {} +
    find "${DEST}" -type f -exec chmod 640 {} +
    chmod -R 770 "${DEST}/upload" "${DEST}/images/model" "${DEST}/backup" "${DEST}/_SQL"
    chown -R www-data:www-data /var/lib/php/sessions
    chmod 660 "${DEST}/connect.php"

    #--------------------------------------------------
    # Configuring Apache
    #--------------------------------------------------
    echo "Configuring Apache security settings..."
    # Ensure ServerTokens is set to Prod
    if grep -qE '^ServerTokens\s+' "${SEC_CONF}"; then
        sed -i 's/^ServerTokens.*/ServerTokens Prod/' "${SEC_CONF}"
    else
        echo 'ServerTokens Prod' >> "${SEC_CONF}"
    fi
    # Ensure ServerSignature is Off
    if grep -qE '^ServerSignature\s+' "${SEC_CONF}"; then
        sed -i 's/^ServerSignature.*/ServerSignature Off/' "${SEC_CONF}"
    else
        echo 'ServerSignature Off' >> "${SEC_CONF}"
    fi

    #--------------------------------------------------
    # Mark GestSup as installed
    #--------------------------------------------------
    echo "Marking GestSup as installed..."
    touch "${DEST}/.installed"
else
    echo "GestSup is already installed. Skipping first install setup."
fi

#--------------------------------------------------
# Start Apache in the foreground
#--------------------------------------------------
echo "Starting Apache..."
exec apachectl -D "FOREGROUND"
#--------------------------------------------------
# End of script
#--------------------------------------------------