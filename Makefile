############# 客製化 #######################################################
env = customized # 填入環境（customized代表使用自定義的變數）
rime_folder = # 填入用戶資料夾路徑
cp = # 填入複製用的指令

# 複製時會以「${cp} ${source} ${rime_folder}」的型式執行

############# 以下內容不需更改 ##############################################
known_env = cmd, msys, termux, customized
source = array30.schema.yaml
source += array30.dict.yaml
source += array30_main.dict.yaml
source += array30_emoji.dict.yaml
source += array30_query.schema.yaml
source += array30_query.dict.yaml
source += array30_wsymbols.schema.yaml
source += array30_wsymbols.dict.yaml

ifeq "$(strip ${env})" "cmd"
  rime_folder = "${USERPROFILE}\AppData\Roaming\rime"
  cp = xcopy /y /d /i
  source = *.yaml 		# xcopy不支援多檔案作為來源檔參數，所以以萬用字元代替

else ifeq "$(strip ${env})" "msys"
  rime_folder = "$(subst \,/,$(subst C:\,/c/,${USERPROFILE}))/AppData/Roaming/rime"
  cp = cp -fvu

else ifeq "$(strip ${env})" "termux"
  rime_folder = "~/storage/shared/rime"
  cp = cp -fvu

else ifneq "$(strip ${env})" "customized"
  $(info Warning: 未知的env: ${env})
  $(info Tip:     可用的env: ${known_env})
  $(error )
endif

ifeq "$(and ${rime_folder},${cp})" ""
  $(info Warning: rime_folder或cp未定義)
  $(info Tip:     輸入「make help」瞭解如何設置)
  varNdef = true
endif

##########
### rules
##########
.PHONY: install help

install:
ifneq "${varNdef}" "true"
	${cp} ${source} ${rime_folder}
endif

help:
	@echo +  關於這個檔案：
	@echo +    該makefile可以幫助你直接將Rime行列輸入方案移動到你的用戶資
	@echo +    料夾內。
	@echo +  
	@echo +  使用說明：
	@echo +    方法１．輸入「make env="環境名"」，make會依據你指定的env，
	@echo +           來設置相關的變數。
	@echo +           可用的環境名： ${known_env}
	@echo +
	@echo +    方法２．直接編輯Makefile中「客製化」註釋下相關的變數，並於
	@echo +           儲存後輸入「make」執行。

