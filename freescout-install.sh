CONTAINER_ALREADY_STARTED="FREESCOUT_INSTALLED"
if [ ! -e $CONTAINER_ALREADY_STARTED ]; then
    touch $CONTAINER_ALREADY_STARTED
    echo "-- First container startup --"
    echo "-- installing freescout --"
    # YOUR_JUST_ONCE_LOGIC_HERE
    ### Set Defaults
    RELEASE_URL=$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/freescout-helpdesk/freescout/releases/latest)
    FREESCOUT_VERSION="${RELEASE_URL##*/}"
    mkdir -p /www/logs && \
    mkdir -p /www/html && \
    curl -sSL https://github.com/freescout-helpdesk/freescout/archive/${FREESCOUT_VERSION}.tar.gz | tar xvfz - --strip 1 -C /www/html && \
    chown -R nginx:www-data /www/html
    chmod -R ug+rwx /www/html/storage /www/html/bootstrap/cache /www/html/public/css/builds /www/html/public/js/builds
else
    echo "-- Not first container startup --"
    echo "-- continuing boot --"
fi
