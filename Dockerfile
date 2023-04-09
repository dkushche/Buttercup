FROM alpine:3.16.2 as download

ENV BUTTERCUP_VERSION=v2.18.2

RUN wget https://github.com/buttercup/buttercup-desktop/releases/download/${BUTTERCUP_VERSION}/Buttercup-linux-x86_64.AppImage

RUN chmod +x Buttercup-linux-x86_64.AppImage

FROM debian:bullseye-20221024-slim

RUN apt-get update && apt-get install -y libatk-bridge2.0-0 \
                                         libsecret-1-0 \
                                         libgbm-dev \
                                         libasound2 \
                                         libgtk-3-0 \
                                         xdg-utils \
                                         libnss3 \
                                         libdrm2 \
                                         wget

COPY --from=download /Buttercup-linux-x86_64.AppImage /home/

WORKDIR /home

COPY entrypoint.sh .

RUN ./Buttercup-linux-x86_64.AppImage --appimage-extract

ENTRYPOINT [ "./entrypoint.sh" ]
