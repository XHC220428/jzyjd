; �ýű�ʹ�� HM VNISEdit �ű��༭���򵼲���

; ��װ�����ʼ���峣��
!define PRODUCT_NAME "��ս�ҽ���"
!define PRODUCT_VERSION "v1.0"
!define PRODUCT_PUBLISHER "QFIT"
!define PRODUCT_WEB_SITE "none"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\jzyjd.exe"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

SetCompressor lzma

; ------ MUI �ִ����涨�� (1.67 �汾���ϼ���) ------
!include "MUI.nsh"

; MUI Ԥ���峣��
!define MUI_ABORTWARNING
!define MUI_ICON "jzyjd\icon.ico"
!define MUI_UNICON "jzyjd\icon.ico"

; ��ӭҳ��
!insertmacro MUI_PAGE_WELCOME
; ���Э��ҳ��
!insertmacro MUI_PAGE_LICENSE "jzyjd\licence.txt"
; ��װĿ¼ѡ��ҳ��
!insertmacro MUI_PAGE_DIRECTORY
; ��װ����ҳ��
!insertmacro MUI_PAGE_INSTFILES
; ��װ���ҳ��
!define MUI_FINISHPAGE_RUN "$INSTDIR\jzyjd.exe"
!insertmacro MUI_PAGE_FINISH

; ��װж�ع���ҳ��
!insertmacro MUI_UNPAGE_INSTFILES

; ��װ�����������������
!insertmacro MUI_LANGUAGE "SimpChinese"

; ��װԤ�ͷ��ļ�
!insertmacro MUI_RESERVEFILE_INSTALLOPTIONS
; ------ MUI �ִ����涨����� ------

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "��ս�ҽ���_v1.0_Windows_FullInstall.exe"
InstallDir "$PROGRAMFILES\jzyjd"
InstallDirRegKey HKLM "${PRODUCT_UNINST_KEY}" "UninstallString"
ShowInstDetails show
ShowUnInstDetails show

Section "MainSection" SEC01
  SetOutPath "$INSTDIR"
  SetOverwrite ifnewer
  File "jzyjd\jzyjd.exe"
  CreateDirectory "$SMPROGRAMS\��ս�ҽ���v1.0"
  CreateShortCut "$SMPROGRAMS\��ս�ҽ���v1.0\��ս�ҽ���.lnk" "$INSTDIR\jzyjd.exe"
  CreateShortCut "$DESKTOP\��ս�ҽ���.lnk" "$INSTDIR\jzyjd.exe"
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
  CreateShortCut "$SMPROGRAMS\��ս�ҽ���\Uninstall.lnk" "$INSTDIR\uninst.exe"
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
 *  �����ǰ�װ�����ж�ز���  *
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

  Delete "$SMPROGRAMS\��ս�ҽ���v1.0\Uninstall.lnk"
  Delete "$DESKTOP\��ս�ҽ���.lnk"
  Delete "$SMPROGRAMS\��ս�ҽ���v1.0\��ս�ҽ���.lnk"

  RMDir "$SMPROGRAMS\��ս�ҽ���v1.0"
  RMDir "$INSTDIR\resources"
  RMDir "$INSTDIR\maps"

  RMDir "$INSTDIR"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  SetAutoClose true
SectionEnd

#-- ���� NSIS �ű��༭�������� Function ���α�������� Section ����֮���д���Ա��ⰲװ�������δ��Ԥ֪�����⡣--#

Function un.onInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "��ȷʵҪ��ȫ�Ƴ� $(^Name) ���������е������" IDYES +2
  Abort
FunctionEnd

Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) �ѳɹ��ش����ļ�����Ƴ���"
FunctionEnd
