call azsphere device sideload delete
call azsphere device sideload deploy --image-package build/xrt-app.imagepackage
call azsphere device app stop --componentid 4a1f4b12-bf60-4dc3-8ce9-bc585c009c5f
call azsphere device app start --debug --componentid 4a1f4b12-bf60-4dc3-8ce9-bc585c009c5f
