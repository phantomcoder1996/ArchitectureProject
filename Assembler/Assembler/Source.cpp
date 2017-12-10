#include<iostream>
#include<string>
#include<vector>
#include<algorithm>
#include <fstream>
#include <bitset>
using namespace std;
string output;
string twoOP[11] = { "MOV", "ADD", "ADC", "SUB", "SBC","AND","OR","XOR","BIS","BIC","CMP" };
string twoOPbin[11] = { "0000", "0001", "0010", "0011", "0100","0101","0110","0111","1000","1001","1010" };
//ro,r1,r2,r3
string registers[4] = { "00","01","10","11" };
//register,Auto_increment,Auto_decrement,Indexed
string modes[4] = { "00","01","10","11" };
/////////////////
string oneOP[11] = { "INC","DEC","CLR","INV","LSR","ROR","RRC","ASR","LSL","ROL","RLC" };
string oneOPbin[11] = { "0000", "0001", "0010", "0011", "0100","0101","0110","0111","1000","1001","1010" };
/////////////////////////////////////////////////////////////
string branch[7] = { "BR","BEQ","BNE","BLO","BLS","BHI","BHS" };
string opbranch[7] = { "000","001","010","011","100","101","110" };
///////////////////////////////////////////////////////////////
string  nooperation[4] = { "HLT","NOP","RESET","RTS" };
string nooperationopcode[4] = { "00","01","10","11" };
////////////////////////////////////////////////////////////////
vector<pair<string, int>> branches;
vector<pair<string, int>> subrotines;
vector<string> v;
int finddd(string s1, string s2)
{
	std::size_t found = s1.find(s2);
	if (found != std::string::npos)
	{
		std::cout << "first 'needle' found at: " << found << '\n';
		return found;
	}
	return -1;
}
string decode_reg(string src, string s,int mode  ) //mod e=0 2 ops i want to fetch dst//mode==1 fetching dst //mode==2
{
	string h = "";
	h += 'R';
	int dis = finddd(src, h);


	if (dis==0|| src[dis - 1] == ' ' || src[dis - 1] == ',' )
	{
		output += modes[0];
		output += '0';
		output += registers[src[dis+1] - '0'];
		if(mode==0)
		return src.substr(2, src.size());
		else return "";
	}
	else if (src[dis - 1] == '(' &&(src[dis - 2] == ' '|| src[dis - 2] == ','))
	{
		output += modes[1];
		output += '0';
		output += registers[src[dis + 1] - '0'];
		if (mode == 0)
		return src.substr(5, src.size());
		else return "";
	}
	else if (src[dis - 2] == '-')
	{
		output += modes[2];
		output += '0';
		output += registers[src[dis + 1] - '0'];
		if (mode == 0)
		return src.substr(5, src.size());
		else return "";
	}
	else
	{
		output += modes[3];
		output += '0';
		output += registers[src[dis + 1] - '0'];
		if (mode == 0)
		return src.substr(5, src.size());
		else return "";
	}

}
void decode_2ops(int x, string s)
{
	output += "00";
	string opcc = twoOP[x];
	output += twoOPbin[x];
	std::string src = s.substr(opcc.size(), s.size());
	string dst= decode_reg( src,   s, 0);
	decode_reg(dst,  s, 1);
	output += '\n';
}

void decode_1op(int x, string s)
{
	output += "01";
	string opcc = oneOP[x];
	output += oneOPbin[x];
	std::string src = s.substr(opcc.size(), s.size());
	decode_reg(src, s, 1);
	output += "00000";
	output += '\n';
}

void decode_br(int x,string s)
{
	output += "11";
	string opcc = branch[x];
	output += opbranch[x];
	for (int i = 0; i < branches.size(); i++)
	{
		int dis = finddd(s, branches[i].first);
		if (dis != 0)
		{ 
			int offset = branches[i].second +1 - x;
			//offset = -offset;
			std::string ss = std::bitset< 11 >(offset).to_string();
			output += ss;
			break;
		}

	}
	output += '\n';
}
void decode_noop(int x, string s)
{
	output += "10";
	string opcc = nooperation[x];
	output += nooperationopcode[x];
	output += "000000000000";
	output += '\n';

}

void decode_jsr(int x, string s)
{
	output += "10";
	output += "011";
	string label= s.substr(3, s.size());
	for (int i = x + 1; i < v.size(); i++)
	{
		int dis = finddd(s, label);
		if (dis != 0)
		{
			int offset = x;
			//offset = -offset;
			std::string ss = std::bitset< 11 >(offset).to_string();
			output += ss;
			break;
		}


	}
	
	
	output += '\n';
}
int main()
{
	string mov_code = "001";
	string Register = "00";
	string Auto_increment = "01";
	string Auto_decrement = "10";
	string Indexed = "11";
	

	

	
	int cnt = 0;
	string line;
	ifstream myfile("Input.txt");
	if (myfile.is_open())
	{
		while (getline(myfile, line))
		{
			cout << line << '\n';
			transform(line.begin(), line.end(), line.begin(), ::toupper);
			v.push_back(line);
		}
		myfile.close();
	}

	else cout << "Unable to open file";
	for (int i = 0; i < v.size(); i++)
	{
		string s = v[i];
		string h = "";
		h += ':';
		int dis= finddd(s, h);
		if (dis != -1)
		{
			string br= s.substr(0, dis);
			s = s.substr(br.size()+2, s.size());
			branches.push_back({br,i});
		}
		bool fnd_2op = false;
		bool fnd_1op = false;
		bool fnd_branch = false;
		bool fnd_nooper = false;
		for (int j = 0; j < 11; j++)
		{
			int dist = finddd(s, twoOP[j]);
			if (dist != -1)
			{
				decode_2ops(j, s);
				fnd_2op = true;
				break;
			}		
		}
		if (!fnd_2op)
		{
			for (int j = 0; j < 11; j++)
			{
				int dist = finddd(s, oneOP[j]);
				if (dist != -1)
				{
					decode_1op(j, s);
					fnd_1op = true;
					break;
				}
			}
		}
		if (!fnd_1op)
		{
			for (int j = 0; j < 7; j++)
			{
				int dist = finddd(s, branch[j]);
				if (dist != -1)
				{
					decode_br(j, s);
					fnd_branch = true;
					break;
				}
			}
		}

		if (!fnd_branch)
		{
			for (int j = 0; j < 4; j++)
			{
				int dist = finddd(s, nooperation[j]);
				if (dist != -1)
				{
					decode_noop(j, s);
					fnd_nooper = true;
					break;
				}
			}
		}
		if (!fnd_nooper)
		{

			int dist = finddd(s, "JSR");
			if (dist != -1)
			{
				decode_jsr(i, s);
			}
			
		}


	}

	ofstream myfile1("output.txt");
	if (myfile1.is_open())
	{
		
		myfile1 << output;
		myfile1.close();
	}
	else cout << "Unable to open file";
	return 0;

}