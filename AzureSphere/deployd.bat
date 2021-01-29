azsphere device sideload delete
azsphere device sideload deploy --imagepackage build/xrt-app.imagepackage
azsphere device app stop --componentid 4a1f4b12-bf60-4dc3-8ce9-bc585c009c5f
azsphere device app start --debug --componentid 4a1f4b12-bf60-4dc3-8ce9-bc585c009c5f
