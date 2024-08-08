{ Copyright (C) 2024 by Bill Stewart (bstewart at iname.com)

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

function AnsiToUnicodeString(const AnsiStr: AnsiString; const CodePage: UINT): UnicodeString;

function UnicodeStringToAnsi(const UnicodeStr: UnicodeString; const CodePage: UINT): AnsiString;

function ExpandEnvStrings(const UnicodeStr: UnicodeString): UnicodeString;

function LowercaseString(const UnicodeStr: UnicodeString): UnicodeString;

function UppercaseString(const UnicodeStr: UnicodeString): UnicodeString;

function SameString(const UnicodeStr1, UnicodeStr2: UnicodeString): Boolean;

implementation

type
  TStringCaseMap = (
    StringCaseMapLowercase = LCMAP_LOWERCASE,
    StringCaseMapUppercase = LCMAP_UPPERCASE
    );

function AnsiToUnicodeString(const AnsiStr: AnsiString; const CodePage: UINT): UnicodeString;
var
  NumChars: DWORD;
  pBuffer: PWideChar;
begin
  result := '';
  NumChars := MultiByteToWideChar(CodePage,  // UINT   CodePage
    0,                                       // DWORD  dwFlags
    PAnsiChar(AnsiStr),                      // LPCCH  lpMultiByteStr
    -1,                                      // int    cbMultiByte
    nil,                                     // LPWSTR lpWideCharStr
    0);                                      // int    cchWideChar
  if NumChars = 0 then
    exit;
  GetMem(pBuffer, NumChars * SizeOf(WideChar));
  if MultiByteToWideChar(CodePage,  // UINT   CodePage
    0,                              // DWORD  dwFlags
    PAnsiChar(AnsiStr),             // LPCCH  lpMultiByteStr
    -1,                             // int    cbMultiByte
    pBuffer,                        // LPWSTR lpWideCharStr
    NumChars) > 0 then              // int    cchWideChar
  begin
    result := pBuffer;
  end;
  FreeMem(pBuffer);
end;

function UnicodeStringToAnsi(const UnicodeStr: UnicodeString; const CodePage: UINT): AnsiString;
var
  NumChars: DWORD;
  pBuffer: PAnsiChar;
begin
  result := '';
  NumChars := WideCharToMultiByte(CodePage,  // UINT   CodePage
    0,                                       // DWORD  dwFlags
    PWideChar(UnicodeStr),                   // LPCWCH lpWideCharStr
    -1,                                      // int    cchWideChar
    nil,                                     // LPSTR  lpMultiByteStr
    0,                                       // int    cbMultiByte
    nil,                                     // LPCCH  lpDefaultChar
    nil);                                    // LPBOOL lpUsedDefaultChar
  if NumChars = 0 then
    exit;
  GetMem(pBuffer, NumChars * SizeOf(AnsiChar));
  if WideCharToMultiByte(CodePage,  // UINT   CodePage
    0,                              // DWORD  dwFlags
    PWideChar(UnicodeStr),          // LPCWCH lpWideCharStr
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

function ExpandEnvStrings(const UnicodeStr: UnicodeString): UnicodeString;
var
  NumChars: DWORD;
  pBuffer: PWideChar;
begin
  NumChars := ExpandEnvironmentStringsW(PWideChar(UnicodeStr),  // LPCWSTR lpSrc
    nil,                                                        // LPWSTR  lpDst
    0);                                                         // DWORD   nSize
  if NumChars = 0 then
  begin
    result := UnicodeStr;  // On failure, return original string
    exit;
  end;
  GetMem(pBuffer, NumChars * SizeOf(WideChar));
  if ExpandEnvironmentStringsW(PWideChar(UnicodeStr),  // LPCWSTR lpSrc
    pBuffer,                                           // LPWSTR  lpDst
    NumChars) > 0 then                                 // DWORD   nSize
  begin
    result := pBuffer;
  end;
  FreeMem(pBuffer);
end;
function MapStringToCase(const S: UnicodeString; const StringCaseMap: TStringCaseMap): UnicodeString;
var
  NumChars: DWORD;
  pBuffer: PWideChar;
begin
  result := '';
  if S = '' then
    exit;
  NumChars := LCMapStringW(LOCALE_USER_DEFAULT,  // LCID    Locale
    DWORD(StringCaseMap),                        // DWORD   dwMapFlags
    PWideChar(S),                                // LPCWSTR lpSrcStr
    -1,                                          // int     cchSrc
    nil,                                         // LPWSTR  lpDestStr
    0);                                          // int     cchDest
  if NumChars = 0 then
    exit;
  GetMem(pBuffer, NumChars * SizeOf(WideChar));
  if LCMapStringW(LOCALE_USER_DEFAULT,  // LCID    Locale
    DWORD(StringCaseMap),               // DWORD   dwMapFlags
    PWideChar(S),                       // LPCWSTR lpSrcStr
    -1,                                 // int     cchSrc
    pBuffer,                            // LPWSTR  lpDestStr
    NumChars) > 0 then                  // int     cchDest
  begin
    result := pBuffer;
  end;
  FreeMem(pBuffer);
end;

function LowercaseString(const UnicodeStr: UnicodeString): UnicodeString;
begin
  result := MapStringToCase(UnicodeStr, StringCaseMapLowercase);
end;

function UppercaseString(const UnicodeStr: UnicodeString): UnicodeString;
begin
  result := MapStringToCase(UnicodeStr, StringCaseMapUppercase);
end;

function SameString(const UnicodeStr1, UnicodeStr2: UnicodeString): Boolean;
const
  CSTR_EQUAL = 2;
begin
  result := CompareStringW(LOCALE_USER_DEFAULT,  // LCID    Locale
    LINGUISTIC_IGNORECASE,                       // DWORD   dwCmpFlags
    PWideChar(UnicodeStr1),                      // PCNZWCH lpString1
    -1,                                          // int     cchCount1
    PWideChar(UnicodeStr2),                      // PCNZWCH lpString2
    -1) = CSTR_EQUAL;                            // int     cchCount2
end;

begin
end.
