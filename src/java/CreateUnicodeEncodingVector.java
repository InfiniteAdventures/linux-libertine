/*
 * Copyright (C) 2007-2009 The ExTeX Group and individual authors listed below
 * 
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 * 
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with this library; if not, write to the Free Software Foundation, Inc.,
 * 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */

import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.util.HashMap;
import java.util.Map;

import org.extex.font.format.texencoding.EncWriter;

/**
 * Create an encoding vector for Unicode ranges.
 * 
 * @author <a href="mailto:m.g.n@gmx.de">Michael Niedermair</a>
 * @version $Revision$
 */
public class CreateUnicodeEncodingVector {

   private static String int2hex(int val) {

      String hex = "00" + Integer.toHexString(val);
      return hex.substring(hex.length() - 2).toUpperCase();
   }

   /**
    * main.
    * 
    * @param args The command line.
    * @throws Exception if an error occurred.
    */
   public static void main(String[] args) throws Exception {

      if (args.length != 4) {
         System.err
               .println("java CreateUnicodeEncodingVector <firsthex> <encname> <Namelist> <file-output>");
         System.exit(1);
      }

      String encname = args[1];

      File namelist = new File(args[2]);
      Map<String, String> names = new HashMap<String, String>(0xffff);

      BufferedReader in = new BufferedReader(new FileReader(namelist));
      String line;
      while ((line = in.readLine()) != null) {
         String[] split = line.split(" ", 2);
         String key = split[0].trim().replaceAll("0x", "");
         String val = split[1].trim();
         names.put(key, val);
      }
      in.close();

      File encfile = new File(args[3]);

      EncWriter enc = new EncWriter();
      enc.setEncname(encname);

      for (int i = 0; i < 256; i++) {
         String uc = args[0] + int2hex(i);
         String value = names.get(uc);
         if (value != null) {
            enc.setEncoding(i, "/" + value);
         } else {
            enc.setEncoding(i, "/uni" + uc);
         }
      }

      enc.write(new FileOutputStream(encfile));

      System.out.println(encfile + " created");
   }
}
