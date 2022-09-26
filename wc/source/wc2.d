import std.algorithm, std.stdio, std.string;
import std.algorithm.iteration;
import std.ascii;

void main(string[] args)
{
    const uint CHUNK_SIZE = 0x10000;
    version (isWhite)
    {
        alias isBlank = isWhite;
    }
    else
    {
        alias isBlank = isBlankChar;
    }
    try
    {
        ulong wordCount = 0;
        dchar lastChar = ' ';
        foreach (chunk; File(args[1]).byChunk(CHUNK_SIZE))
        {
            if (chunk.empty)
                break;
            bool discardFirst = !isBlank(lastChar) && !isBlank(chunk[0]);
            version (each) //faster
            {
                version (split)
                {
                    chunk.splitter!(x => isBlank(x))
                        .each!(w => wordCount += !w.empty);
                }
                else
                {
                
                    wordCount += countWords(chunk);
                }

            }
            else
            {
                version (split)
                {
                    wordCount += chunk.splitter!(x => isBlank(x))
                        .map!(w => w.empty)
                        .sum();
                }
                else
                {
                    wordCount += countWords(chunk);
                }
            }
            //if (discardFirst)
            {
                wordCount -= discardFirst;
            }
            lastChar = chunk[chunk.length - ulong(1)];
        }
        writeln(wordCount);
    }
    catch (Exception e)
    {
        stderr.writeln("Error: ", e);
    }
}


/* static ulong countWords(const ref ubyte[] s) pure nothrow @nogc
{
    ulong cnt = 0;
    const ulong l = s.length;
    auto p = &s[0];
    const auto e = p + l;
    version (isWhite)
    {
        alias isBlank = isWhite;
    }
    else
    {
        alias isBlank = isBlankChar;
    }
    while (p < e)
    {
        //advance to next non blank char or end
        while (p < e && isBlank(*p))
        {
            ++p;
        }
        if (p >= e)
            break;
        //found word -> increment counter
        ++cnt;
        //advance to next blank char or end
        while (p < e && !isBlank(*p))
        {
            ++p;
        }
        if (p >= e)
            break;
    }
    return cnt;
}*/

static ulong countWords(const ref ubyte[] s) pure nothrow @nogc
{
    const ulong l = s.length;
    auto p = &s[0];
    const auto e = p + l;
    version (isWhite)
    {
        alias isBlank = isWhite;
    }
    else
    {
        alias isBlank = isBlankChar;
    }
    ulong cnt = 0; //!isBlank(*p++);
    ubyte lastChar = ' ';
    while (p < e)
    {
        if(isBlank(lastChar) && !isBlank(*p)) ++cnt;
        lastChar = *p++;
    }
    return cnt;
}

static ulong[2] countWordsAndLines(const ref ubyte[] s) pure nothrow @nogc
{
    const ulong l = s.length;
    auto p = &s[0];
    const auto e = p + l;
    version (isWhite)
    {
        alias isBlank = isWhite;
    }
    else
    {
        alias isBlank = isBlankChar;
    }
    ulong wordCnt = 0;
    ulong lineCnt = 0;
    ubyte lastChar = ' ';
    while (p < e)
    {
        if(isBlank(lastChar) && !isBlank(*p)) ++wordCnt;
        if(*p == '\n') ++lineCnt;
        lastChar = *p++;
    }
    return [lineCnt, wordCnt];
}

static ulong countLines(const ref ubyte[] s) pure nothrow @nogc
{
    const ulong l = s.length;
    auto p = &s[0];
    const auto e = p + l;
    ulong lineCnt = 0;
    while (p < e)
    {
        if(*p == '\n') ++lineCnt;
    }
    return lineCnt;
}

static bool isBlankChar(dchar c) @safe pure nothrow @nogc
{
    //copied from isWhite implementation
    return c == ' ' || (c >= 0x09 && c <= 0x0D);
}
