# WindowsString.pp

## Author

Bill Stewart (bstewart AT iname.com)

## License

**WindowsString.pp** is covered by the GNU Lesser Public License (LPGL). See the file `LICENSE` for details.

## Description

**WindowsString.pp** is a Free Pascal (FPC) unit for the Windows platform that contains string functions handled by Windows API calls.

## Reference

This section documents the functions in the unit.

---

### AnsiToUnicodeString

Converts an **AnsiString** string to a **UnicodeString** string using the **MultiByteToWideChar** API.

#### Syntax

```
function AnsiToUnicodeString(const AnsiStr: AnsiString; const CodePage: UINT): UnicodeString;
```

#### Parameters

`AnsiStr` - Specifies the **AnsiString** string to be converted to a **UnicodeString** string.

`CodePage` - Specifies the code page for the conversion. Usually, this will be `CP_ACP` or `CP_OEM`.

#### Return Value

The **AnsiString** string `AnsiStr` converted to a **UnicodeString** string. If the conversion fails, the function returns an empty **UnicodeString** string.

#### Remarks

See the Windows API documentation for the **MultiByteToWideChar** API for more information about the `CodePage` parameter.

---

### UnicodeToAnsiString

Converts a **UnicodeString** string to an **AnsiString** string using the **WideCharToMultiByte** API.

#### Syntax

```
function UnicodeStringToAnsi(const UnicodeStr: UnicodeString; const CodePage: UINT): AnsiString;
```

#### Parameters

`UnicodeStr` - Specifies the **UnicodeString** string to be converted to an **AnsiString** string.

`CodePage` - Specifies the code page for the conversion. Usually, this will be `CP_ACP` or `CP_OEM`.

#### Return Value

The **UnicodeString** string `UnicodeStr` converted to an **AnsiString** string. If the conversion fails, the function returns an empty **AnsiString** string.

#### Remarks

See the Windows API documentation for the **WideCharToMultiByte** API for more information about the `CodePage` parameter.

---
### ExpandEnvStrings

Returns a **UnicodeString** string with environment variable references expanded using the **ExpandEnvironmentStrings** API.

#### Syntax

```
function ExpandEnvStrings(const UnicodeStr: UnicodeString): UnicodeString;
```

#### Parameters

`UnicodeStr` - Specifies the **UnicodeString** string containing environment variable references (e.g., `%variablename%`).

#### Return Values

The **UnicodeString** string `UnicodeStr` with environment variable references expanded.

#### Remarks

Environment variable references are environment variable names surrounded by `%` characters (e.g., `%variablename%`). For each such reference, the function replaces the `%variablename%` portion with the current value of the named environment variable. Environment variable names between `%` characters are not case-sensitive. If the function does not find an environment variable name, it does not expand that portion of the string.

---

### LowercaseString

Returns a **UnicodeString** string in lowercase using the **LCMapStringW** API.

#### Syntax

```
function LowercaseString(const UnicodeStr: UnicodeString): UnicodeString;
```

#### Parameters

`UnicodeStr` - Specifies the **UnicodeString** string to be returned as lowercase.

#### Return Value

The **UnicodeString** string `UnicodeStr` in lowercase. If the case mapping fails, the function returns an empty **UnicodeString** string.

---

### UppercaseString

Returns a **UnicodeString** string in uppercase using the **LCMapStringW** API.

#### Syntax

```
function UppercaseString(const UnicodeStr: UnicodeString): UnicodeString;
```

#### Parameters

`UnicodeStr` - Specifies the **UnicodeString** string to be returned as uppercase.

#### Return Value

The **UnicodeString** string `UnicodeStr` in uppercase. If the case mapping fails, the function returns an empty **UnicodeString** string.

---

### SameString

Tests whether two **UnicodeString** strings match case-insensitively using the **CompareStringW** API.

#### Syntax

```
function SameString(const UnicodeStr1, UnicodeStr2: UnicodeString): Boolean;
```

#### Parameters

`UnicodeStr1` - Specifies the first **UnicodeString** string to compare.

`UnicodeStr2` - Specifies the second **UnicodeString** string to compare.

#### Return Value

The function returns `true` if the strings match, or `false` otherwise. The match is not case-sensitive.
