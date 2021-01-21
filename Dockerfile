FROM alpine:latest as build

WORKDIR /root/busybox

RUN apk add --no-cache build-base linux-headers

COPY . ./

ENV LDFLAGS=--static

RUN yes "" | make defconfig
RUN make -j8
RUN sh make_single_applets.sh

RUN mkdir dist
RUN rm -f busybox*.log busybox_unstripped busybox_unstripped*
RUN mv busybox dist
RUN mv busybox_* dist

FROM scratch

COPY --from=build /root/busybox/dist /bin
