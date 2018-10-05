FROM nginx:1.15.1-alpine

RUN apk update && apk add php7-phpdbg

ENV PATH=${PATH}:/root/.composer/vendor/bin/
RUN apk update \
    && apk add php7-phar \
    && apk add php7-json \
    && apk add php7-openssl \
    && apk add php7-mbstring \
    && apk add php7-tokenizer \
    && php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer \
    && composer global require leanphp/phpspec-code-coverage

RUN rm -rf /var/cache/apk/* /var/tmp/*/tmp/*

WORKDIR /code
ADD site.conf /etc/nginx/conf.d/default.conf

ADD shape /usr/local/bin/shape
ADD coverage.sh /usr/local/bin/coverage
ADD test-coverage.php /usr/local/bin/test-coverage
ADD phpspec-html.yml /code/phpspec-html.yml
ADD phpspec-text.yml /code/phpspec-text.yml

ENV CLASS_COVERAGE_MAX 100
ENV CLASS_COVERAGE_MIN 0
ENV METHOD_COVERAGE_MAX 100
ENV METHOD_COVERAGE_MIN 0
ENV LINE_COVERAGE_MAX 100
ENV LINE_COVERAGE_MIN 0
