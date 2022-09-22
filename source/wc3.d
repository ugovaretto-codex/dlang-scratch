import std.file;
import std.stdio;
import std.ascii;

ulong countWords(char[] s)
{
    ulong cnt = 0;
    ulong l =  s.length;
    ulong i = 0;
    while (i < l)
    {
        //advance to next non blank char or end
        while (i < l && s[i++].isWhite) {}
        if (i >= l) break;
        //found word -> increment counter
        ++cnt;
        //advance to next blank char or end
        while (i < l && !s[i++].isWhite) {}
        if (i >= l) break;
    }
    return cnt;
}

void main(string[] args)
{
    auto f = File(args[1]);
    ulong wordCount = 0;
    ulong lineCount = 0;
    char[] buf;
    while (!f.eof)
    {
        f.readln(buf);
        ++lineCount;
        wordCount += countWords(buf); 
    }
    writeln(lineCount - 1, " ", wordCount);
}
