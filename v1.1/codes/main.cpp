#include<graphics.h>
#include<conio.h>
#include<windows.h>
#include<ctime>
#include<cmath>
#include<fstream>
#include<iostream>
#define KEY_DOWN(VK_NONAME) ((GetAsyncKeyState(VK_NONAME)& 0x8000)?1:0)
int mhddis(int x1,int y1,int x2,int y2){return abs(x1-x2)+abs(y1-y2);}
using namespace std;
long long Tick,LastTick=-1;
struct _operations{
	bool W,A,S,D,I,J,K,L;
	bool C,N,Cl,Nl;
	void Refresh(){
		if(KEY_DOWN('W')) this->W=1;
		else this->W=0;
		if(KEY_DOWN('A')) this->A=1;
		else this->A=0;
		if(KEY_DOWN('S')) this->S=1;
		else this->S=0;
		if(KEY_DOWN('D')) this->D=1;
		else this->D=0;
		if(KEY_DOWN('I')) this->I=1;
		else this->I=0;
		if(KEY_DOWN('J')) this->J=1;
		else this->J=0;
		if(KEY_DOWN('K')) this->K=1;
		else this->K=0;
		if(KEY_DOWN('L')) this->L=1;
		else this->L=0;
		Cl=C,Nl=N;
		if(KEY_DOWN('C')) this->C=1;
		else this->C=0;
		if(KEY_DOWN('N')) this->N=1;
		else this->N=0;
	}
}Operations;
struct _resources{
	struct _maps{
		COLORREF Main[501][501];
	}Maps;
	struct _icons{
		IMAGE Player1,Player2;
		IMAGE PlayerHurt;
		IMAGE HeartFill,HeartUnfill;
		IMAGE FireResistancePotion;
	}Icons;
	void Load(){
		fstream f;
		int r,g,b;
		f.open("maps/main.map",ios::in);
		for(int i=0;i<500;i++){
			for(int j=0;j<500;j++){
				f>>r>>g>>b;
				this->Maps.Main[i][j]=RGB(r,g,b);
			}
		}
		f.close();
		loadimage(&this->Icons.Player1,_T("resources/player1.ico"));
		loadimage(&this->Icons.Player2,_T("resources/player2.ico"));
		loadimage(&this->Icons.PlayerHurt,_T("resources/player_hurt.ico"));
		loadimage(&this->Icons.HeartFill,_T("resources/heart_fill.ico"),15,15);
		loadimage(&this->Icons.HeartUnfill,_T("resources/heart_unfill.ico"),15,15);
		loadimage(&this->Icons.FireResistancePotion,_T("resources/potion_fire_resistance.ico"));
	}
}Resources;
void RefreshScreen(int l,int t,int r,int b){
	for(int i=l;i<=r;i++)
		for(int j=t;j<=b;j++)
			if(i>=0&&i<=499&&j>=0&&j<=499) putpixel(i,j,Resources.Maps.Main[i][j]);
}
struct _potions{
	int FireResistanceX,FireResistanceY;
	bool FireResistanceFlag;
	int FireResistanceOwner,FireResistanceStartTime;
	void Dealing(){
		for(int i=0;i<=7;i++)
			if((Tick>>i)%2) return;
		RefreshScreen(this->FireResistanceX,this->FireResistanceY,this->FireResistanceX+20,this->FireResistanceY+20);
		this->FireResistanceX=rand()%480;
		this->FireResistanceY=rand()%480;
		while(1){
			if(GetBValue(Resources.Maps.Main[this->FireResistanceX+5][this->FireResistanceY+5])==170)
				if(GetBValue(Resources.Maps.Main[this->FireResistanceX+15][this->FireResistanceY+5])==170)
					if(GetBValue(Resources.Maps.Main[this->FireResistanceX+5][this->FireResistanceY+15])==170)
						if(GetBValue(Resources.Maps.Main[this->FireResistanceX+15][this->FireResistanceY+15])==170)
							break;
			this->FireResistanceX=rand()%480;
			this->FireResistanceY=rand()%480;
		}
		putimage(this->FireResistanceX,this->FireResistanceY,&Resources.Icons.FireResistancePotion);
		for(int i=this->FireResistanceX;i<this->FireResistanceX+20;i++)
			for(int j=this->FireResistanceY;j<this->FireResistanceY+20;j++)
				if(getpixel(i,j)==0xffffff) RefreshScreen(i,j,i,j);
	}
}Potions;
struct _players{
	struct _player{
		unsigned int BirthPointX,BirthPointY; 
		unsigned int NowX,NowY;
		unsigned int LastX,LastY;
		short Blood,Score;
		bool HurtFlag;
		long long HurtDuring;
		void Rebirth(){NowX=BirthPointX,NowY=BirthPointY,Blood=10,Score++;}
		void DoesHarm(int v){Blood-=v,HurtDuring=Tick;}
	}Player1,Player2;
	double PlayerDistance;
	string NumberCmp="0123456789";
	void Dealing(){
		if(Operations.W&&this->Player1.NowY>0) this->Player1.NowY-=5;
		if(Operations.S&&this->Player1.NowY<480) this->Player1.NowY+=5;
		if(Operations.A&&this->Player1.NowX>0) this->Player1.NowX-=5;
		if(Operations.D&&this->Player1.NowX<480) this->Player1.NowX+=5;
		if(Operations.I&&this->Player2.NowY>0) this->Player2.NowY-=5;
		if(Operations.K&&this->Player2.NowY<480) this->Player2.NowY+=5;
		if(Operations.J&&this->Player2.NowX>0) this->Player2.NowX-=5;
		if(Operations.L&&this->Player2.NowX<480) this->Player2.NowX+=5;
		if(Player1.LastX!=Player1.NowX||Player1.LastY!=Player1.NowY)
			RefreshScreen(Player1.LastX,Player1.LastY,Player1.LastX+19,Player1.LastY+19);
		if(Player2.LastX!=Player2.NowX||Player2.LastY!=Player2.NowY)
			RefreshScreen(Player2.LastX,Player2.LastY,Player2.LastX+19,Player2.LastY+19);
		Player1.LastX=Player1.NowX,Player1.LastY=Player1.NowY;
		Player2.LastX=Player2.NowX,Player2.LastY=Player2.NowY;
		putimage(Player1.NowX,Player1.NowY,Player1.HurtFlag?&Resources.Icons.PlayerHurt:&Resources.Icons.Player1);
		putimage(Player2.NowX,Player2.NowY,Player2.HurtFlag?&Resources.Icons.PlayerHurt:&Resources.Icons.Player2);
		//伤害计算 
		PlayerDistance=mhddis(Player1.NowX,Player1.NowY,Player2.NowX,Player2.NowY);
		/*osdis=sqrt((Player1.NowX-Player2.NowX)*(Player1.NowX-Player2.NowX)+(Player1.NowY-Player2.NowY)*(Player1.NowY-Player2.NowY))*/
		if(!Player1.HurtFlag){
			if(!Operations.N&&Operations.Nl) Player1.DoesHarm(PlayerDistance>30?0:2);/*cout<<"["<<Tick<<"] P1受到伤害"<<endl;*/
			if(!GetGValue(Resources.Maps.Main[Player1.NowX+10][Player1.NowY+10])) Player1.DoesHarm(1);
		}
		if(!Player2.HurtFlag){
			if(!Operations.C&&Operations.Cl) Player2.DoesHarm(PlayerDistance>30?0:2);/*cout<<"["<<Tick<<"] P2受到伤害"<<endl;*/
			if(!GetGValue(Resources.Maps.Main[Player2.NowX+10][Player2.NowY+10])) Player2.DoesHarm(1);
		}
		Player1.HurtFlag=Tick>=Player1.HurtDuring&&Tick<Player1.HurtDuring+10?true:false;
		Player2.HurtFlag=Tick>=Player2.HurtDuring&&Tick<Player2.HurtDuring+10?true:false;
		Player1.Blood=max(0,int(Player1.Blood));
		Player2.Blood=max(0,int(Player2.Blood));
		if(!Player1.Blood) Player1.Rebirth();
		if(!Player2.Blood) Player2.Rebirth();
		//血量渲染 
		for(int i=1;i<=10;i++){
			putimage(520+i*15,15,(Player1.Blood>=i?&Resources.Icons.HeartFill:&Resources.Icons.HeartUnfill));
			putimage(520+i*15,45,(Player2.Blood>=i?&Resources.Icons.HeartFill:&Resources.Icons.HeartUnfill));
		}
		outtextxy(530,80,NumberCmp[Player2.Score/10]);
		outtextxy(560,80,NumberCmp[Player2.Score%10]);
		outtextxy(590,80,":");
		outtextxy(620,80,NumberCmp[Player1.Score/10]);
		outtextxy(650,80,NumberCmp[Player1.Score%10]);
	}
}Players;
struct _gametick{
	SYSTEMTIME NowTime;
	void TickStep(){
		Operations.Refresh();
//		Potions.Dealing();
		Players.Dealing();
	}
	void Dealing(){
		GetLocalTime(&this->NowTime);
		Tick=this->NowTime.wMilliseconds/100;
		Tick+=this->NowTime.wSecond*20;//(this->NowTime.wSecond<<4)+(this->NowTime.wSecond<<2);
		Tick+=this->NowTime.wMinute*1200;
		Tick+=this->NowTime.wHour*72000;
		if(Tick!=LastTick){
			LastTick=Tick;
			this->TickStep();
		}
	}
}GameTick;
void Initialize(){
	initgraph(700,500/*,EX_SHOWCONSOLE*/);
	settextstyle(40,20,"宋体");
	settextcolor(BLACK); 
	setbkcolor(LIGHTGRAY);
	cleardevice();
	Resources.Load();
	RefreshScreen(0,0,500,500);
	setlinecolor(BLACK);
	for(int i=500;i<=504;i++)
		line(i,0,i,499);
	putimage(510,10,&Resources.Icons.Player1);
	putimage(510,40,&Resources.Icons.Player2);
	Players.Player1.BirthPointX=60;
	Players.Player1.BirthPointY=60;
	Players.Player2.BirthPointX=/*75*/420;
	Players.Player2.BirthPointY=/*75*/420;
	Players.Player1.Score=Players.Player2.Score=-1;
	srand(time(0));
}
int main(){
	Initialize();
	while(1) GameTick.Dealing();
}
