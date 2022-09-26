import std.stdio;
import std.parallelism;
import std.array;
import core.thread;
import std.exception;

void main(string[] args)
{
    try
    {
        enforce(args.length > 1, "Error: no file name specified");
        const ulong length = DirEntry(args[1]).size;
        const offset = length / 4;
        auto task0 = task!wc(args[1], 0, offset);
        auto task1 = task!wc(args[1], offset, 2 * offset);
        auto task2 = task!wc(args[1], 2 * offset, 3 * offset);
        auto task3 = task!wc(args[1], 3 * offset, -1);

        task0.executeInNewThread();
        task1.executeInNewThread();
        task2.executeInNewThread();
        task3.executeInNewThread();

        immutable res = task0.yieldForce() + task1.yieldForce() + task2.yieldForce() + task3.yieldForce();
        writeln(res);
    }
    catch(Exception e)
    {
        stderr.writeln("Error: ", e);
    }
}

import std.file;
import std.stdio;
import std.ascii;
import std.range;

ulong wc(string fname, long offset, long maxOffset)
{
    try
    {
        auto f = File(fname);
        f.seek(offset);
        ulong wordCount = 0;
        //ulong lineCount = 0;
        const auto SZ = 0x10000; 
        char[SZ] buf;
        dchar lastChar = ' ';
        if (maxOffset < 0)
        {
            while (!f.eof)
            {
                auto r = f.rawRead(buf);
                if (r.empty) break;
                //++lineCount;
                wordCount += countWords(r);
                if (!isBlankChar(lastChar) && !isBlankChar(r[0])) wordCount -= 1;
                lastChar = r[r.length - ulong(1)];
            }
        }
        else
        {
            while(f.tell() < maxOffset)
            {
                import std.algorithm;
                auto mx = min(maxOffset - f.tell(), buf.length);
                auto r = f.rawRead(buf[0..mx]);
                if (r.empty) break;
                //++lineCount;
                wordCount += countWords(r);
                if (!isBlankChar(lastChar) && !isBlankChar(r[0])) wordCount -= 1;
                lastChar = r[r.length - ulong(1)];
            }
        }
        return wordCount;
    }
    catch (Exception e)
    {
        stderr.writeln("Error! ", e);
    }
    return 0;
}

static ulong countWords(char[] s) pure @nogc nothrow @safe
{
    if (s.empty)
        return 0;
    ulong cnt = 0;
    ulong l = s.length;
    ulong i = 0;
    version (isWhite)
    {
        alias isBlank = isWhite;
    }
    else
    {
        alias isBlank = isBlankChar;
    }
    while (i < l)
    {
        //advance to next non blank char or end
        while (i < l && isBlank(s[i]))
        {
            ++i;
        }
        if (i >= l)
            break;
        //found word -> increment counter
        ++cnt;
        //advance to next blank char or end
        while (i < l && !isBlank(s[i]))
        {
            ++i;
        }
        if (i >= l)
            break;
    }
    return cnt;
}

static bool isBlankChar(dchar c) @safe pure nothrow @nogc
{
    //copied from isWhite implementation
    return c == ' ' || (c >= 0x09 && c <= 0x0D);
}
