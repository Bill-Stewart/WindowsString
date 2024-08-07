{ Copyright (C) 2023-2024 by Bill Stewart (bstewart at iname.com)

  This program is free software; you can redistribute it and/or modify it under
  the terms of the GNU Lesser General Public License as published by the Free
  Software Foundation; either version 3 of the License, or (at your option) any
  later version.

  This program is distributed in the hope that it will be useful, but WITHOUT
  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
  FOR A PARTICULAR PURPOSE. See the GNU General Lesser Public License for more
  details.

  You should have received a copy of the GNU Lesser General Public License
  along with this program. If not, see https://www.gnu.org/licenses/.

}

unit WindowsString;

{$MODE OBJFPC}
{$MODESWITCH UNICODESTRINGS}

interface

uses
  windows;

function AnsiToUnicodeString(const AAnsiStr: AnsiString; const CodePage: UINT): UnicodeString;

function UnicodeStringToAnsi(const AUnicodeStr: UnicodeString; const CodePage: UINT): AnsiString;

implementation

function AnsiToUnicodeString(const AAnsiStr: AnsiString; const CodePage: UINT): UnicodeString;
var
  NumChars, BufSize: DWORD;
  pBuffer: PChar;
begin
  result := '';
  // Get number of characters needed for buffer
  NumChars := MultiByteToWideChar(CodePage,  // UINT   CodePage
    0,                                       // DWORD  dwFlags
    PAnsiChar(AAnsiStr),                     // LPCCH  lpMultiByteStr
    -1,                                      // int    cbMultiByte
    nil,                                     // LPWSTR lpWideCharStr
    0);                                      // int    cchWideChar
  if NumChars > 0 then
  begin
    BufSize := NumChars * SizeOf(WideChar);
    GetMem(pBuffer, BufSize);
    if MultiByteToWideChar(CodePage,  // UINT   CodePage
      0,                              // DWORD  dwFlags
      PAnsiChar(AAnsiStr),            // LPCCH  lpMultiByteStr
      -1,                             // int    cbMultiByte
      pBuffer,                        // LPWSTR lpWideCharStr
      NumChars) > 0 then              // int    cchWideChar
    begin
      result := pBuffer;
    end;
    FreeMem(pBuffer);
  end;
end;

function UnicodeStringToAnsi(const AUnicodeStr: UnicodeString; const CodePage: UINT): AnsiString;
var
  NumChars, BufSize: DWORD;
  pBuffer: PAnsiChar;
begin
  result := '';
  // Get number of characters needed for buffer
  NumChars := WideCharToMultiByte(CodePage,  // UINT   CodePage
    0,                                       // DWORD  dwFlags
    PWideChar(AUnicodeStr),                  // LPCWCH lpWideCharStr
    -1,                                      // int    cchWideChar
    nil,                                     // LPSTR  lpMultiByteStr
    0,                                       // int    cbMultiByte
    nil,                                     // LPCCH  lpDefaultChar
    nil);                                    // LPBOOL lpUsedDefaultChar
  if NumChars > 0 then
  begin
    BufSize := NumChars * SizeOf(AnsiChar);
    GetMem(pBuffer, BufSize);
    if WideCharToMultiByte(CodePage,  // UINT   CodePage
      0,                              // DWORD  dwFlags
      PWideChar(AUnicodeStr),         // LPCWCH lpWideCharStr
      -1,                             // int    cchWideChar
      pBuffer,                        // LPSTR  lpMultiByteStr
      NumChars,                       // int    cbMultiByte
      nil,                            // LPCCH  lpDefaultChar
      nil) > 0 then                   // LPBOOL lpUsedDefaultChar
    begin
      result := pBuffer;
    end;
    FreeMem(pBuffer);
  end;
end;

end.
