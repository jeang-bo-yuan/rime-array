############# 客製化 #######################################################
env = customized # 填入環境（customized代表使用自定義的變數）
rime_folder = # 填入用戶資料夾路徑
cp = # 填入複製用的指令
rm = # 填入刪除用的指令

# 複製時會以「${cp} _source_ ${rime_folder}」的型式執行

############# 以下內容不需更改 ##############################################
known_env = cmd, msys, termux, customized

ifeq "$(strip ${env})" "cmd"
  rime_folder = ${USERPROFILE}\AppData\Roaming\rime
  cp = copy /y
  rm = del /p

else ifeq "$(strip ${env})" "msys"
  rime_folder = $(subst \,/,$(subst C:\,/c/,${USERPROFILE}))/AppData/Roaming/rime
  cp = cp -fvu
  rm = rm -i

else ifeq "$(strip ${env})" "termux"
  rime_folder = ~/storage/shared/rime
  cp = cp -fvu
  rm = rm -i

else ifneq "$(strip ${env})" "customized"
  $(info Warning: 未知的env: ${env})
  $(info Tip:     可用的env: ${known_env})
  $(error )
endif

ifeq "$(and ${rime_folder},${cp},${rm})" ""
  $(info Warning: 變數定義未完整，即將停止輸入方案的安裝)
  $(info Tip:     輸入「make help」瞭解如何設置)
  $(info Tip:     輸入「make print」檢視哪些變數尚未定義)
  varNdef = true
endif

##########
### rules
##########
.PHONY: install install_pre help print

install:
ifneq "${varNdef}" "true"
	@echo 安裝array30輸入方案中......
	@${cp} *.yaml ${rime_folder}
endif

install_pre: install
ifneq "${varNdef}" "true"
ifeq "${env}" "cmd"
	@echo 安裝array30_query二進制字典與稜鏡中......
	@${cp} "array30_query-precompiled/array30_query*" "${rime_folder}\build"
	@echo 是否要刪除array30_query輸入方案？（y/n）
	@${rm} "${rime_folder}\array30_query.*.yaml"
#因為del只認得以'\'分割目錄的路徑名，所以另外寫了一個條件判斷並以'\'分割目錄名
else
	@echo 安裝array30_query二進制字典與稜鏡中......
	@${cp} array30_query-precompiled/array30_query* ${rime_folder}/build
	@echo 是否要刪除array30_query輸入方案？（y/n）
	@${rm} ${rime_folder}/array30_query.*.yaml
endif
endif

help:
	@echo "+  關於這個檔案："
	@echo "+    本makefile可以幫助你直接將Rime行列輸入方案移動到你的用戶資"
	@echo "+    料夾內。"
	@echo "+  "
	@echo "+  變數設置："
	@echo "+    在使用本makefile時，需要同時設置必要的變數來讓make知道你所"
	@echo "+    在的環境。"
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
	@echo "+    help        印出本說明"
	@echo "+    print       印出變數設置"

print:
	@echo "+ rime_folder = ${rime_folder}"
	@echo "+ cp = ${cp}"
	@echo "+ rm = ${rm}"
	@echo "+ "
	@echo "+ # 複製時會以「${cp} _source_ ${rime_folder}」的型式執行"
