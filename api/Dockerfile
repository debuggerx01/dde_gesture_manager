FROM dart:stable AS build-env
LABEL stage=dart_builder
ENV PUB_HOSTED_URL="https://pub.flutter-io.cn"
ENV ANGEL_ENV=production
COPY ./ ./
RUN pub get
RUN bash source_gen.sh && dart compile exe bin/prod.dart -o /server
ENTRYPOINT ["dart", "bin/migrate.dart", "up"]

FROM scratch
WORKDIR /app
ENV ANGEL_ENV=production
ADD ./views ./views
ADD ./config ./config
COPY --from=build-env /runtime/ /
COPY --from=build-env /server /app
EXPOSE 3000
ENTRYPOINT ["./server", "-a", "0.0.0.0", "--port", "3000"]