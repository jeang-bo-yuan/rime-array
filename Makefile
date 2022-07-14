############# 客製化 #######################################################
env := customized # 填入環境（customized代表使用下列的自定義變數）
rime_folder := # 填入用戶資料夾路徑
cp := # 填入複製用的指令
rm := # 填入刪除用的指令
DS := # 填入目錄分隔符（Directory Separator）

# 複製時會以「${cp} _source_ ${rime_folder}」的型式執行

############# 以下內容不需更改 ##############################################
known_env := cmd, msys, termux, customized
schema := array30

env := $(strip ${env})
rime_folder := $(strip ${rime_folder})
cp := $(strip ${cp})
rm := $(strip ${rm})
DS := $(strip ${DS})

ifeq "${env}" "cmd"
  rime_folder := ${USERPROFILE}\AppData\Roaming\rime
  cp := copy /y
  rm := del /p
  DS := \\

else ifeq "${env}" "msys"
  rime_folder := $(subst \,/,$(subst C:\,/c/,${USERPROFILE}))/AppData/Roaming/rime
  cp := cp -fvu
  rm := rm -iv
  DS := /

else ifeq "${env}" "termux"
  rime_folder := ~/storage/shared/rime
  cp := cp -fvu
  rm := rm -iv
  DS := /

else ifneq "${env}" "customized"
  $(info Warning: 未知的env: ${env})
  $(info Tip:     可用的env: ${known_env})
  $(error )
endif

ifeq "$(and ${rime_folder},${cp},${rm},${DS})" ""
  $(info Warning: 變數定義未完整，即將停止輸入方案的安裝／解除安裝)
  $(info Tip:     輸入「make help」瞭解如何設置)
  $(info Tip:     輸入「make print」檢視哪些變數尚未定義)
  varNdef := true
endif

##########
### rules
##########
.PHONY: install install_pre help print

install:
ifneq "${varNdef}" "true"
	@echo 安裝${schema}輸入方案中......
	@${cp} array30*.yaml ${rime_folder}
	@echo 安裝完成，記得重新部署Rime!!
endif

install_pre: install
ifneq "${varNdef}" "true"
	@echo 安裝array30_query二進制字典與稜鏡中......
	@${cp} array30_query-precompiled/array30_query* ${rime_folder}${DS}build
	@echo 是否要刪除array30_query輸入方案？（y/n）
	@${rm} ${rime_folder}${DS}array30_query.*.yaml
	@echo 安裝完成，記得重新部署Rime!!
endif

uninstall:
ifneq "${varNdef}" "true"
	@echo 解除安裝${schema}輸入方案中......
	@${rm} ${rime_folder}${DS}array30*.yaml
	@echo 解除安裝完成!!
endif

help:
	@echo "+  關於這個檔案："
	@echo "+    本makefile可以幫助你直接將Rime行列輸入方案移動到你的用戶資"
	@echo "+    料夾內。"
	@echo "+  "
	@echo "+  變數設置："
	@echo "+    在使用本makefile時，需要同時設置必要的變數來讓make知道你所"
	@echo "+    使用的終端環境。"
	@echo "+    方法１．輸入「make env='環境名'」，make會依據你指定的env，"
	@echo "+           來自動設置相關的變數。"
	@echo "+           可用的環境名： ${known_env}"
	@echo "+"
	@echo "+    方法２．直接編輯Makefile中「客製化」註釋下相關的變數，並於"
	@echo "+           儲存後輸入「make」執行。"
	@echo "+"
	@echo "+  Targets:"
	@echo "+    install     安裝輸入方案到用戶資料夾內 （Default）"
	@echo "+    install_pre 安裝輸入方案+預先編譯好的array30_query二進制"
	@echo "+                字典與稜鏡"
	@echo "+                （並詢問是否刪除array30_query輸入方案）"
	@echo "+    uninstall   解除安裝輸入方案"
	@echo "+    help        印出本說明"
	@echo "+    print       印出變數設置"

print:
	@echo "+ rime_folder = ${rime_folder}"
	@echo "+ cp = ${cp}"
	@echo "+ rm = ${rm}"
	@echo "+ DS = ${DS}"
	@echo "+ "
	@echo "+ # 複製時會以「${cp} _source_ ${rime_folder}」的型式執行"
	@echo "+ # 刪除時會以「${rm} _target_」的型式執行"
	@echo "+ # DS的值是目錄分隔符"
