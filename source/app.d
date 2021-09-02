import raylib;
import basic;
alias digit=int;
enum gridsize=8;
digit[gridsize][gridsize] sudokugrid;
struct specdigit{
	bool[gridsize+2] data =true;
	alias data this;
}
enum boxsize=2;
enum boxes=gridsize/boxsize;
specdigit[gridsize][gridsize] specgrid;
digit[gridsize/boxsize][gridsize/boxsize] colorgrid;
const specdigit[gridsize][gridsize] defualtspecgrid;
enum int[4][] sets=[
	[0,0,0,0],//0 is white
	[1,2,3,4],//red
	[5,6,7,8],
	[1,3,5,7],
	[2,4,6,8]
	//[1,2,7,8],
	//[3,4,5,6]
];
enum Color[] colors=[RAYWHITE,RED,YELLOW,GREEN,BLUE];
struct digitinterface{
	int x; int y;
	ref digit get(){
		return sudokugrid[x-1][y-1];
	}
	alias get this;
	auto ref spec(){
		return specgrid[x-1][y-1];
	}
	auto ref color(){
		return colorgrid[(x-1)/boxsize][(y-1)/boxsize];
	}
}
struct grid_{
	auto ref opIndex(int x,int y){
		return digitinterface(x,y);
	}
}
enum grid=grid_();
bool verifygroup(int[gridsize] i){
	static foreach(j;1..gridsize+1){
		if(i[].count(j) >= 2){return false;}
	}
	return true;
}
bool verifycol(int i){
	int[gridsize] o;
	foreach(j;1..gridsize+1){
		o[j-1]=grid[j,i];
	}
	return o.verifygroup;
}
bool verifyrow(int i){
	int[gridsize] o;
	foreach(j;1..gridsize+1){
		o[j-1]=grid[i,j];
	}
	return o.verifygroup;
}
bool verifyset(int[4] group,int[4] reference){
	static foreach(i;1..gridsize+1){
		if(group[].count(i) >= 2){return false;}
	}
	//---
	foreach(i;group){
		if(i!=0){
			if( ! reference[].canFind(i)){return false;}
	}}
	return true;
}
bool verifybox(int i, int j){
	int[4] temp=[
		grid[i  ,j  ],
		grid[i+1,j  ],
		grid[i  ,j+1],
		grid[i+1,j+1]
	];
	switch(grid[i,j].color){
		case 0://white
			return true;//todo
		case 1:
			return verifyset(temp,[1,2,3,4]);
		case 2:
			return verifyset(temp,[5,6,7,8]);
		case 3:
			return verifyset(temp,[1,3,5,7]);
		case 4:
			return verifyset(temp,[2,4,6,8]);
		default: break;
	}
	"huh".writeln;
	return true;
}
bool verifygrid(){
	foreach(i;1..gridsize+1){
		if( ! verifyrow(i)){ return false;}
	}
	foreach(i;1..gridsize+1){
		if( ! verifycol(i)){ return false;}
	}
	foreach(i;[1,3,5,7]){
	foreach(j;[1,3,5,7]){
		if( ! verifybox(i,j)){return false;}
	}}
	return true;
}
bool verify2groups(int[gridsize*2] group){
	static foreach(i;1..gridsize+1){
		if(group[].count(i) >= 3){return false;}
	}
	return true;
}
bool verifycolors(){
	bool row(int i){
		int[gridsize*2] o;
		o[0..4]=  sets[colorgrid[i][0]];
		o[4..8]=  sets[colorgrid[i][1]];
		o[8..12]= sets[colorgrid[i][2]];
		o[12..16]=sets[colorgrid[i][3]];
		return o.verify2groups();
	}
	bool col(int i){
		int[gridsize*2] o;
		o[0..4]=  sets[colorgrid[0][i]];
		o[4..8]=  sets[colorgrid[1][i]];
		o[8..12]= sets[colorgrid[2][i]];
		o[12..16]=sets[colorgrid[3][i]];
		return o.verify2groups();
	}
	foreach(i;0..4){
		if( ! row(i)){return false;}
		if( ! col(i)){return false;}
	}
	return true;
}
void specgroup(digitinterface[gridsize] group){
	foreach(e;group){
		if(e!=0){
			foreach(f;group){
				f.spec[e]=false;
}}}}
void speccol(int i){
	digitinterface[gridsize] o;
	foreach(j;1..gridsize+1){
		o[j-1]=grid[j,i];
	}
	o.specgroup;
}
void specrow(int i){
	digitinterface[gridsize] o;
	foreach(j;1..gridsize+1){
		o[j-1]=grid[i,j];
	}
	o.specgroup;
}
void specbox(int i, int j){
	digitinterface[gridsize] o;
	int k=0;
	foreach(ii;0..3){
	foreach(jj;0..3){
		o[k]=grid[i+ii,j+jj];
		k++;
	}}
	o.specgroup;
}
void specgrid_(){
	specgrid=defualtspecgrid;
	foreach(i;1..gridsize+1){
		specrow(i);
	}
	foreach(i;1..gridsize+1){
		speccol(i);
	}
	foreach(i;[1,4,7]){
	foreach(j;[1,4,7]){
		specbox(i,j);
	}}
}
bool gridfinished(){
	foreach(i;1..gridsize+1){
	foreach(j;1..gridsize+1){
		if(grid[i,j]==0){return false;}
	}}
	return true;
}
void fillgrid(){
	void fillrestofgrid(int cell){
		int[] a=[1,2,3,4,5,6,7,8].randomShuffle;
		foreach(e;a){
			if(gridfinished && verifygrid){goto exit;}
			grid[(cell/gridsize)+1,(cell%gridsize)+1]=e;
			if(verifygrid){fillrestofgrid(cell+1);}
		}
		if( ! verifygrid){grid[(cell/gridsize)+1,(cell%gridsize)+1]=0;}
		exit:
	}
	fillrestofgrid(0);
}
void fillcolor(){
	void rest(int box){
		int[] a=[1,2,3,4].randomShuffle;
		if(! verifycolors){"colors failed".writeln; goto exit;}
		if(box==4*4){fillgrid;goto exit;}
		foreach(e;a){
			e.writeln;
			if(gridfinished && verifygrid){goto exit;}
			colorgrid[box/4][box%4]=e;
			if(verifygrid){rest(box+1);}
		}
		if( ! verifygrid){colorgrid[box/4][box%4]=0;}
		exit:
	}
	rest(0);
}
void removedigit(){
	grid[uniform(1,9),uniform(1,9)]=0;
}
void removecolor(){
	colorgrid[uniform(0,boxes)][uniform(0,boxes)]=0;
}
enum windowsize=600;
enum numoffset=-54;
void drawnumbers(){
	foreach(i;1..gridsize+1){
	foreach(j;1..gridsize+1){
		if( ! grid[i,j]==0){
			DrawText(int(grid[i,j]).to!string.toStringz, i*(windowsize/gridsize)+numoffset, j*(windowsize/gridsize)+numoffset, 48, BLACK);
	}}}
}
void drawgrid(){
	foreach(i;0..gridsize+1){
		auto v1=Vector2(i*(windowsize/gridsize),0);
		auto v2=Vector2(i*(windowsize/gridsize),windowsize);
		int thick=(i%boxsize==0) ? 6:2;
		DrawLineEx(v1,v2,thick,BLACK);
	}
	foreach(i;0..gridsize+1){
		auto v1=Vector2(0         ,i*(windowsize/gridsize));
		auto v2=Vector2(windowsize,i*(windowsize/gridsize));
		int thick=(i%boxsize==0) ? 6:1;
		DrawLineEx(v1,v2,thick,BLACK);
	}
}

//void drawcolor(){//unbelievably dubouis
//	foreach(i;iota(0,boxes-1)){
//	foreach(j;iota(0,boxes-1)){
//		auto v1=Vector2(i    *(windowsize/boxes),j    *(windowsize/boxes));
//		auto v2=Vector2(i*(windowsize/boxes)+10,j*(windowsize/boxes)+10);
//		DrawRectangleV(v1,v2,colors[grid[i*3+1,j*3+1].color]);
//	}}
//}
void drawcolor(){//unbelievably dubouis
	foreach(i;0..4){
	foreach(j;0..4){
		auto v1=Vector2(i    *(windowsize/boxes),j    *(windowsize/boxes));
		auto v2=Vector2((i+1)*(windowsize/boxes),(j+1)*(windowsize/boxes));
		DrawRectangleV(v1,v2,colors[colorgrid[i][j]]);
	}}
}
void main(){
	InitWindow(windowsize,windowsize, "Hello, Raylib-D!");
	SetWindowPosition(2000,0);
	SetTargetFPS(60);
	//fillgrid;
	fillcolor;
	//removedigit;
	foreach(i;0..20){removedigit;}
	foreach(i;0..10){removecolor;}
	while (!WindowShouldClose()){
		//grid[uniform(1,10),uniform(1,10)]=uniform(1,10);
		BeginDrawing();
			if(IsMouseButtonReleased(0)){
				grid[(GetMouseX*gridsize)/windowsize+1,(GetMouseY*gridsize)/windowsize+1] =
				"zenity --entry".exe.to!int%(gridsize+1);
			}
			if(IsMouseButtonReleased(1)){
				grid[(GetMouseX*gridsize)/windowsize+1,(GetMouseY*gridsize)/windowsize+1].color =
				"zenity --entry".exe.to!int%colors.length;
			}
			ClearBackground(RAYWHITE);
			//DrawText("Hello, World!", 400, 300, 28, BLACK);
			//DrawFPS(10,10);
			drawcolor;
			drawnumbers;
			drawgrid;
			//specgrid_;
			//grid[9,9].spec.writeln;
			if( ! verifygrid){verifygrid.writeln;}
		EndDrawing();
	}
	CloseWindow();
}