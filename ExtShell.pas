unit ExtShell;

interface

uses
  Windows, SysUtils, Registry;

procedure RefreshSystemIcon;

implementation

procedure RefreshSystemIcon;
const
  REG_DESKTOP_ICON_SIZE = 'Control Panel\Desktop\WindowMetrics';
  KEY_SHEEL_ICON_SIZE = 'Shell Icon Size';
var
  Registry: TRegistry;
  IconSize: Integer;

  procedure NotifyChange;
  var
    IconMetrics: TIconMetrics;
  begin
    IconMetrics.cbSize := SizeOf(TIconMetrics);
    SystemParametersInfo(SPI_GETICONMETRICS, 0, @IconMetrics, 0);
    SystemParametersInfo(SPI_SETICONMETRICS, 0, @IconMetrics,
        SPIF_UPDATEINIFILE or SPIF_SENDWININICHANGE);
  end;

begin
  Registry := TRegistry.Create;
  try
    Registry.OpenKey(REG_DESKTOP_ICON_SIZE, False);
    IconSize := StrToIntDef(Registry.ReadString('Shell Icon Size'), 32);
    Registry.WriteString(KEY_SHEEL_ICON_SIZE, IntToStr(IconSize - 1));
    NotifyChange;
    Registry.WriteString(KEY_SHEEL_ICON_SIZE, IntToStr(IconSize));
    NotifyChange;
  finally
    Registry.Free;
  end;
end;

end.