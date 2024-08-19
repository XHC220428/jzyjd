; 该脚本使用 HM VNISEdit 脚本编辑器向导产生

; 安装程序初始定义常量
!define PRODUCT_NAME "决战岩浆岛"
!define PRODUCT_VERSION "v1.0"
!define PRODUCT_PUBLISHER "QFIT"
!define PRODUCT_WEB_SITE "none"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\jzyjd.exe"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

SetCompressor lzma

; ------ MUI 现代界面定义 (1.67 版本以上兼容) ------
!include "MUI.nsh"

; MUI 预定义常量
!define MUI_ABORTWARNING
!define MUI_ICON "jzyjd\icon.ico"
!define MUI_UNICON "jzyjd\icon.ico"

; 欢迎页面
!insertmacro MUI_PAGE_WELCOME
; 许可协议页面
!insertmacro MUI_PAGE_LICENSE "jzyjd\licence.txt"
; 安装目录选择页面
!insertmacro MUI_PAGE_DIRECTORY
; 安装过程页面
!insertmacro MUI_PAGE_INSTFILES
; 安装完成页面
!define MUI_FINISHPAGE_RUN "$INSTDIR\jzyjd.exe"
!insertmacro MUI_PAGE_FINISH

; 安装卸载过程页面
!insertmacro MUI_UNPAGE_INSTFILES

; 安装界面包含的语言设置
!insertmacro MUI_LANGUAGE "SimpChinese"

; 安装预释放文件
!insertmacro MUI_RESERVEFILE_INSTALLOPTIONS
; ------ MUI 现代界面定义结束 ------

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "决战岩浆岛_v1.0_Windows_FullInstall.exe"
InstallDir "$PROGRAMFILES\jzyjd"
InstallDirRegKey HKLM "${PRODUCT_UNINST_KEY}" "UninstallString"
ShowInstDetails show
ShowUnInstDetails show

Section "MainSection" SEC01
  SetOutPath "$INSTDIR"
  SetOverwrite ifnewer
  File "jzyjd\jzyjd.exe"
  CreateDirectory "$SMPROGRAMS\决战岩浆岛v1.0"
  CreateShortCut "$SMPROGRAMS\决战岩浆岛v1.0\决战岩浆岛.lnk" "$INSTDIR\jzyjd.exe"
  CreateShortCut "$DESKTOP\决战岩浆岛.lnk" "$INSTDIR\jzyjd.exe"
  File "jzyjd\help.txt"
  File "jzyjd\icon.ico"
	File "jzyjd\licence.txt"
  SetOutPath "$INSTDIR\maps"
  File "jzyjd\maps\main.map"
  SetOutPath "$INSTDIR\resources"
  File "jzyjd\resources\player2.ico"
  File "jzyjd\resources\player1.ico"
  File "jzyjd\resources\player_hurt.ico"
  File "jzyjd\resources\heart_unfill.ico"
  File "jzyjd\resources\heart_fill.ico"
SectionEnd

Section -AdditionalIcons
  SetOutPath $INSTDIR
  CreateShortCut "$SMPROGRAMS\决战岩浆岛\Uninstall.lnk" "$INSTDIR\uninst.exe"
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\jzyjd.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\jzyjd.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd

/******************************
 *  以下是安装程序的卸载部分  *
 ******************************/

Section Uninstall
  Delete "$INSTDIR\uninst.exe"
  Delete "$INSTDIR\resources\heart_fill.ico"
  Delete "$INSTDIR\resources\heart_unfill.ico"
  Delete "$INSTDIR\resources\player_hurt.ico"
  Delete "$INSTDIR\resources\player1.ico"
  Delete "$INSTDIR\resources\player2.ico"
  Delete "$INSTDIR\maps\main.map"
  Delete "$INSTDIR\help.txt"
  Delete "$INSTDIR\jzyjd.exe"

  Delete "$SMPROGRAMS\决战岩浆岛v1.0\Uninstall.lnk"
  Delete "$DESKTOP\决战岩浆岛.lnk"
  Delete "$SMPROGRAMS\决战岩浆岛v1.0\决战岩浆岛.lnk"

  RMDir "$SMPROGRAMS\决战岩浆岛v1.0"
  RMDir "$INSTDIR\resources"
  RMDir "$INSTDIR\maps"

  RMDir "$INSTDIR"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  SetAutoClose true
SectionEnd

#-- 根据 NSIS 脚本编辑规则，所有 Function 区段必须放置在 Section 区段之后编写，以避免安装程序出现未可预知的问题。--#

Function un.onInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "您确实要完全移除 $(^Name) ，及其所有的组件？" IDYES +2
  Abort
FunctionEnd

Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) 已成功地从您的计算机移除。"
FunctionEnd
