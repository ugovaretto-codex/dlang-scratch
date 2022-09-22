
import std.stdio;
import std.algorithm;

void main(string[] args)
{
    ulong wordCount;
    ulong lineCount;
    ulong charCount;

    int[string] dictionary;
    writeln("   lines   words   bytes file");

    foreach (arg; args[1 .. $])
    {
        ulong lWordCount;
        ulong lCharCount;
        ulong lLineCount;

        auto file = File(arg);
        foreach (line; file.byLine(KeepTerminator.yes))
        {
            lCharCount += line.length;
            foreach (word; splitter(line))
            {
                lWordCount += 1;
                if (auto count = word in dictionary)
                    *count += 1;
                else
                    dictionary[word.idup] = 1;
            }

            lLineCount += 1;
        }

        writefln("%8s%8s%8s %s\n", lLineCount, lWordCount, lCharCount, arg);

        wordCount += lWordCount;
        lineCount += lLineCount;
        charCount += lCharCount;
    }

    const char[37] hr = '-';

    if (args.length > 2)
    {
        writeln(hr);
        writefln("%8s%8s%8s total", lineCount, wordCount, charCount);
    }

    //writeln(hr);

    //foreach (word; sort(dictionary.keys))
    //{
    //        writefln("%3s %s", dictionary[word], word);
    //}
}
