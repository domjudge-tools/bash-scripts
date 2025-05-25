# #!/usr/bin/bash
# echo "please run with root user"
# sudo apt update 


# sudo apt install stardict
# sudo apt install unrar

# echo "Download the farsi dictionary."

# wget https://pdn.sharezilla.ir/d/software/StarDict.English.To.Farsi.hfarsi_p30download.com.rar

# unrar e -r StarDict.English.To.Farsi.hfarsi_p30download.com.rar -pwww.p30download.com

# sudo cp Hfarsi_p30download.com.ifo Hfarsi_p30download.com.idx.oft Hfarsi_p30download.com.idx Hfarsi_p30download.com.dict /usr/share/stardict/dic/stardict-dict/


# echo "OK DICT."

# echo "Install build-essential gdb cmake valgrind default-jdk python3 python3-pip git make."
# sudo apt install -y build-essential gdb cmake valgrind \
#                     default-jdk python3 python3-pip git make

# echo 'int main() {return 0;}' > test.cpp
# g++ test.cpp -o test && echo "✅ g++ OK"

# echo 'int main() {return 0;}' > test.c
# gcc test.c -o test && echo "✅ gcc OK"

# echo -e 'all:\n\tg++ test.cpp -o test' > Makefile
# make && echo "✅ make OK"

# gdb --version && echo "✅ gdb OK"

# cmake --version && echo "✅ cmake OK"

# valgrind --version && echo "✅ valgrind OK"

# echo 'public class Main { public static void main(String[] args) { System.out.println("✅ Java OK"); } }' > Main.java
# javac Main.java && java Main

# python3 --version && echo "✅ Python OK"
# pip3 --version && echo "✅ pip OK"

# git --version && echo "✅ git OK"