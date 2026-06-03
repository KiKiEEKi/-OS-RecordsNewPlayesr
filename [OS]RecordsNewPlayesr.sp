#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo =
{
	name = "[OS] Records New Players",
	author = "KiKiEEKi ( DS: kikieeki | vk.com/kikieeki )",
	version = "( 1.0.1 )"
};

AuthIdType g_authType[4] = {AuthId_Engine, AuthId_Steam2, AuthId_Steam3, AuthId_SteamID64};

//Формат записи steamid
int g_iNum = 2; //0 - AuthId_Engine, 1- AuthId_Steam2, 2 - AuthId_Steam3, 3 - AuthId_SteamID64

public void OnClientPostAdminCheck(int iClient)
{
	if(IsFakeClient(iClient)) return;

	char sFile[45];
	char sSteamId[32];
	FormatTime(sFile, sizeof(sFile), "addons/sourcemod/logs/osrnp/D%dM%mY%Y.log");
	GetClientAuthId(iClient, g_authType[g_iNum], sSteamId, sizeof(sSteamId));

	if(OSFileRead(sFile, sSteamId)) return; //Прочитать игрока из файла

	char sTime[16];
	char sName[32];
	char sIp[16];
	FormatTime(sTime, sizeof(sTime), "%H:%M:%S");
	GetClientName(iClient, sName, sizeof(sName));
	GetClientIP(iClient, sIp, sizeof(sIp));

	OSFileWrite(sFile, sTime, sName, sSteamId, sIp); //Записать игрока в файл
}

bool OSFileRead(const char[] sFile, const char[] sSteamId)
{
	File hFile = OpenFile(sFile, "rt", true);
	if(hFile != INVALID_HANDLE) {
		char sString[128];

		while(!hFile.EndOfFile() && hFile.ReadLine(sString, sizeof(sString))) {
			if(StrContains(sString, sSteamId, false) != -1) {
				delete hFile;
				return true;
			}
		}
	}
	delete hFile;
	return false;
}

void OSFileWrite(const char[] sFile, const char[] sTime, const char[] sName, const char[] sSteamId, const char[] sIp)
{
	File hFile = OpenFile(sFile, "at", true);
	if(hFile != INVALID_HANDLE) {
		hFile.WriteLine("Время [%s] Никнейм [%s] SteamId [%s] Ip [%s]", sTime, sName, sSteamId, sIp);
	}
	delete hFile;
}
