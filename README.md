# WindowsString.pp

## Author

Bill Stewart (bstewart AT iname.com)

## License

**WindowsString.pp** is covered by the GNU Lesser Public License (LPGL). See the file `LICENSE` for details.

## Description

**WindowsString.pp** is a Free Pascal (FPC) unit for the Windows platform that contains a pair of functions for converting an **AnsiString** string to a **UnicodeString** string and vice-versa using Windows API calls.

## Reference

This section documents the functions in the unit.

---

### AnsiToUnicodeString

Converts an **AnsiString** string into a **UnicodeString** string using the Windows **MultiByteToWideChar** API.

#### Syntax

```
function AnsiToUnicodeString(const AAnsiStr: AnsiString; const CodePage: UINT): UnicodeString;
```

#### Parameters

`AAnsiStr` - Specifies the **AnsiString** to be converted to a **UnicodeString**.

`CodePage` - Specifies the code page for the conversion. Usually, this will be `CP_ACP` or `CP_OEM`.

#### Return Value

The string `AAnsiStr` converted to a **UnicodeString** string.

---

### UnicodeToAnsiString

Converts a **UnicodeString** string into an **AnsiString** string using the Windows **WideCharToMultiByte** API.

#### Syntax

```
function UnicodeStringToAnsi(const AUnicodeStr: UnicodeString; const CodePage: UINT): AnsiString;
```

#### Parameters

`AUnicodeStr` - Specifies the **UnicodeString** to be converted to an **AnsiString**.

`CodePage` - Specifies the code page for the conversion. Usually, this will be `CP_ACP` or `CP_OEM`.

#### Return Value

The string `AUnicodeStr` converted to an **AnsiString** string.
