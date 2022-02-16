call azsphere device sideload delete
call azsphere device sideload deploy --image-package build/xrt-app.imagepackage
call azsphere device app stop --component-id 4a1f4b12-bf60-4dc3-8ce9-bc585c009c5f
call azsphere device app start --debug-mode --component-id 4a1f4b12-bf60-4dc3-8ce9-bc585c009c5f
"C:\Program Files (x86)\Microsoft Azure Sphere SDK\Sysroots\11\tools\gcc\arm-poky-linux-musleabi-gdb.exe" build\xrt-app.out
