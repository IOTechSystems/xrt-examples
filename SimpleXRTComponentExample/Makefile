build: libmycomponent.so

libmycomponent.so: component/mycomponent.c component/mycomponent.h
	gcc -I${IOT_DIR}/include -I${XRT_DIR}/include -L${IOT_DIR}/lib -L${XRT_DIR}/lib -fpic -shared component/mycomponent.c -liot -o component/libmycomponent.so

clean:
	rm libmycomponent.so