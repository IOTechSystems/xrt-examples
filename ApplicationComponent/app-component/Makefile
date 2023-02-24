IOT_DIR=/opt/iotech/iot/1.4
XRT_DIR=/opt/iotech/xrt/2.1

build: libapp-component.so

libapp-component.so: app-component.c app-component.h
	gcc -I${IOT_DIR}/include -I${XRT_DIR}/include -L${IOT_DIR}/lib -L${XRT_DIR}/lib -fpic -shared app-component.c -liot -o libapp-component.so

clean:
	rm libapp-component.so