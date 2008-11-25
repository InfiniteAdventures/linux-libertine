/*
 * $Id$
 */
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Arrays;
import java.util.HashMap;

/**
 * Groups the glyphs in groups.
 * 
 * @author Michael Niedermair
 */
public class GroupGlyphs {

    /**
     * The glyph array.
     */
    private static String[] glyphArray;

    /**
     * Check, if a block is empty
     * 
     * @return <code>true</code>, if the block is empty.
     */
    private static boolean empty(int block) {

        int group = block * 256;
        for (int i = group; i < group + 256; i++) {
            if (!glyphArray[i].equals(".notdef")) { return false; }
        }
        return true;
    }

    /**
     * COnvert a int to hex 4 digit hex string.
     * 
     * @param i The int value.
     */
    private static String int2hex(int i) {
        StringBuilder buf = new StringBuilder();
        buf.append("0000");
        buf.append(Integer.toHexString(i));
        return buf.substring(buf.length() - 4);
    }

    /**
     * main.
     * 
     * @param args The command line
     * @throws IOException if an error occurred.
     */
    public static void main(String[] args) throws IOException {

        if (args.length != 3) {
            System.err
                    .println("java GroupGlyphs <fxlgylphname.txt> <LinLibertine.nam> <outDir/fxlgroupglyphs.tex>");
            System.exit(1);
        }

        HashMap<String, String> nam = new HashMap<String, String>();
        BufferedReader namIn = new BufferedReader(new FileReader(args[1]));
        String line;
        while ((line = namIn.readLine()) != null) {
            // 0x0020 space
            String[] split = line.split(" ", 2);
            String key = split[1];
            String val = split[0].replaceAll("0x", "").trim();
            nam.put(key, val);
        }
        namIn.close();

        glyphArray = new String[0xffff + 1];
        Arrays.fill(glyphArray, ".notdef");

        BufferedReader glyIn = new BufferedReader(new FileReader(args[0]));
        while ((line = glyIn.readLine()) != null) {
            // aacute.sc
            // uni1F65
            String hex = "";
            String name = line;
            if (!line.startsWith(".notdef")) {
                if (line.startsWith("uni") && line.length() == 7) {
                    hex = line.replaceAll("uni", "");
                } else {
                    hex = nam.get(name);
                }
                // System.out.println(hex + " - " + name);
                try {
                    glyphArray[Integer.parseInt(hex, 16)] = name;
                } catch (NumberFormatException e) {
                    // ignore
                    System.out.println(hex + " - " + name);
                }
            }
        }
        glyIn.close();

        BufferedWriter out = new BufferedWriter(new FileWriter(args[2]), 0xffff);
        for (int group = 0; group < 256; group++) {
            if (!empty(group)) {
                out.write("\\GROUPHEAD{" + int2hex(group * 256) + "}\n");
                for (int l = 0; l < 256; l++) {
                    int v = group * 256 + l;
                    if (!glyphArray[v].equals(".notdef")) {
                        out.write("   \\GROUPGLYPH{" + int2hex(v) + "}{" + glyphArray[v] + "}");
                    }
                }
                out.write("\\GROUPFOOT{}\n");
            }
        }
        out.write("\\endinput\n");
        out.close();
    }
}
