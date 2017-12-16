#include<iostream>
#include<string>
#include<vector>
#include<algorithm>
#include <fstream>
#include <bitset>
#include<iomanip>
#include<sstream>
using namespace std;
string output;
string twoOP[11] = { "MOV", "ADD", "ADC", "SUB", "SBC","AND","OR","XOR","BIS","BIC","CMP" };
string twoOPbin[11] = { "1001", "0000", "0001", "0010", "0011","0101","0111","0110","0111","1000","0100" };
//ro,r1,r2,r3
string registers[4] = { "00","01","10","11" };
//register,Auto_increment,Auto_decrement,Indexed
string modes[4] = { "00","01","10","11" };
/////////////////
string oneOP[11] = { "INC","DEC","CLR","INV","LSR","ROR","RRC","ASR","LSL","ROL","RLC" };
string oneOPbin[11] = { "0001", "0011", "0000", "0010", "1111","1001","1010","1101","1110","1011","1100" };
/////////////////////////////////////////////////////////////
string branch[7] = { "BR","BEQ","BNE","BLO","BLS","BHI","BHS" };
string opbranch[7] = { "000","001","010","011","100","101","110" };
///////////////////////////////////////////////////////////////
string  nooperation[4] = { "HLT","NOP","RESET","RTS" };
string nooperationopcode[4] = { "000","001","010","100" };
////////////////////////////////////////////////////////////////
vector<pair<string, int>> branches;
vector<pair<string, int>> subrotines;
vector<string> v;
vector<pair<int, int>>data_v;
string xxx;
string data_output;
int cnt_num_code_line;
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
		///////////////to do output x in file////////////////////////////////
		string num;
		for (int i = 0; i <s.size( ); i++)
		{
			if (src[i] >= '0' && src[i] <= '9')num += src[i];
			if (src[i] == '(') break;
		}
		///////////////////////change string to int then to biteset and output to file////////////////////////////////////////////////////
		int x = stoi(num.c_str());

		std::stringstream stream;
		stream << std::hex << cnt_num_code_line;
		std::string result(stream.str());
		xxx += result;
		xxx += ':';
		xxx += ' ';


		xxx += bitset<16>(x).to_string();
		xxx += "\n";
		cnt_num_code_line += 1;
		if (mode == 0)
		return src.substr(5, src.size());
		else return "";
	}

}

string decode_reg_1_op(string src, string s) 
{
	string h = "";
	h += 'R';
	int dis = finddd(src, h);


	if (dis == 0 || src[dis - 1] == ' ' || src[dis - 1] == ',')
	{
		output += modes[0];
		
		output += registers[src[dis + 1] - '0'];
		
		 return "";
	}
	else if (src[dis - 1] == '(' && (src[dis - 2] == ' ' || src[dis - 2] == ','))
	{
		output += modes[1];
		
		output += registers[src[dis + 1] - '0'];
		
		 return "";
	}
	else if (src[dis - 2] == '-')
	{
		output += modes[2];
		
		output += registers[src[dis + 1] - '0'];
		
		 return "";
	}
	else
	{
		output += modes[3];
		
		output += registers[src[dis + 1] - '0'];
		///////////////to do output x in file////////////////////////////////
		string num;
		for (int i = 0; i <s.size(); i++)
		{
			if (src[i] >= '0' && src[i] <= '9')num += src[i];
			if (src[i] == '(') break;
		}
		///////////////////////change string to int then to biteset and output to file////////////////////////////////////////////////////
		std::stringstream stream;
		stream << std::hex << cnt_num_code_line;
		std::string result(stream.str());
		xxx += result;
		xxx += ':';
		xxx += ' ';
		int x = stoi(num.c_str());
		xxx += bitset<16>(x).to_string();
		xxx += "\n";
		cnt_num_code_line += 1;
		 return "";
	}

}
void decode_2ops(int x, string s)
{
	std::stringstream stream;
	stream << std::hex << cnt_num_code_line;
	std::string result(stream.str());
	output += result;
	output += ':';
	output += ' ';
	output += "00";
	string opcc = twoOP[x];
	output += twoOPbin[x];
	cnt_num_code_line += 1;
	std::string src = s.substr(opcc.size(), s.size());
	string dst= decode_reg( src,   s, 0);
	decode_reg(dst,  s, 1);
	output += '\n';
	if (xxx != "")
	{
		output += xxx;
		
	}
}

void decode_1op(int x, string s)
{
	std::stringstream stream;
	stream << std::hex << cnt_num_code_line;
	std::string result(stream.str());
	output += result;
	output += ':';
	output += ' ';
	cnt_num_code_line += 1;
	output += "01";
	string opcc = oneOP[x];
	output += oneOPbin[x];
	std::string src = s.substr(opcc.size(), s.size());
	decode_reg_1_op(src, s);
	output += "000000";
	output += '\n';
	if (xxx != "")
	{
		output += xxx;
		
	}
}

void decode_br(int x,string s)
{
	std::stringstream stream;
	stream << std::hex << cnt_num_code_line;
	std::string result(stream.str());
	output += result;
	output += ':';
	output += ' ';
	cnt_num_code_line += 1;
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
	std::stringstream stream;
	stream << std::hex << cnt_num_code_line;
	std::string result(stream.str());
	output += result;
	output += ':';
	output += ' ';
	cnt_num_code_line += 1;
	output += "10";
	string opcc = nooperation[x];
	output += nooperationopcode[x];
	output += "00000000000";
	output += '\n';

}

void decode_jsr(int x, string s)
{
	std::stringstream stream;
	stream << std::hex << cnt_num_code_line;
	std::string result(stream.str());
	output += result;
	output += ':';
	output += ' ';
	cnt_num_code_line += 1;
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
/////////////////////////handle data input
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
	bool nodata = false;
	if (myfile.is_open())
	{
		while (getline(myfile, line))
		{
			if (nodata)
			{
				int num1;
				int num2;
				string s1="", s2="";
				for (int i = 0; i < line.size(); i++)
				{
					if (line[i] >= '0'&&line[i] <= '9')
						s1 += line[i];
					if (line[i] == ' ') break;

				}
				num1 = stoi(s1.c_str());
				line= line.substr( s1.size(),line.size());
				for (int i = 0; i < line.size(); i++)
				{
					if (line[i] >= '0'&&line[i] <= '9')
						s2 += line[i];
					

				}
				num2 = stoi(s2.c_str());
				data_v.push_back({num1,num2});

			}
			if ( !nodata)

			{
				transform(line.begin(), line.end(), line.begin(), ::toupper);
				v.push_back(line);
			}
			if (line == "") nodata = true;
		}
		myfile.close();
	}

	else cout << "Unable to open file";
	for (int i = 0; i < v.size(); i++)
	{
		string s = v[i];
		string h = "";
		xxx = "";
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
	int cnnt = 0;
	
	for (int i = cnt_num_code_line; i <= data_v[data_v.size() - 1].first; i++)
	{
		if (i < data_v[cnnt].first) { 
			
			std::stringstream stream;
			stream << std::hex << i;
			std::string result(stream.str());
			data_output += result;
			data_output += ':';
			data_output += ' ';
			
			data_output += '\n'; }
		else if (i == data_v[cnnt].first)
		{
			std::stringstream stream;
			stream << std::hex << i;
			std::string result(stream.str());
			data_output += result;
			data_output += ':';
			data_output += ' ';

			data_output += bitset<16>(data_v[cnnt].second).to_string();
			data_output += '\n';
			cnnt++;
		}

	}
	ofstream myfile1("output.txt");
	if (myfile1.is_open())
	{
		
		myfile1 << output;
		myfile1 << data_output;
		myfile1.close();
	}
	else cout << "Unable to open file";
	return 0;

} 