#!/usr/bin/env sh

FILE="$1"
COMMAND="phpdbg -qrr /root/.composer/vendor/bin/phpspec run -f pretty -v"
if [ "$FILE" = 'html' ]; then
    shape exec --command "$COMMAND" --shape phpspec.yml extensions=phpspec-html.yml
elif [ "$FILE" = 'text' ]; then
    RXCLASSES="Classes: *(?P<classes>\d{1,3}\.\d{2})%"
    RXMETHODS="Methods: *(?P<methods>\d{1,3}\.\d{2})%"
    RXLINES="Lines: *(?P<lines>\d{1,3}\.\d{2})%"
    REGEXP="$RXCLASSES.*\n.*$RXMETHODS.*\n.*$RXLINES"
    shape exec --command "$COMMAND" --regexp "$REGEXP" --shape phpspec.yml extensions=phpspec-text.yml
    test-coverage
else
    echo "Call with either 'html' or 'text' as the first argument"
fi
