build: libexample-device.so

libexample-device.so: example-device.c example-device.h
	gcc -I${IOT_DIR}/include -I${XRT_DIR}/include -L${IOT_DIR}/lib -L${XRT_DIR}/lib -fpic -shared example-device.c -liot -lxrt-devsdk -o libexample-device.so

clean:
	rm libexample-device.so
