FROM igormaka/swift-libpostal

RUN apt-get install libsqlite3-dev

ADD . /code
WORKDIR /code
RUN swift build
ENV INTERPOLATION_DATA_DIR /interpolation
EXPOSE 9999
CMD [ ".build/debug/InterpolationService" ]