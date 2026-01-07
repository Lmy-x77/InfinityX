--!nocheck
--!nolint

--[[
    @author biggaboy212
    @name VantaUI

    This file was automatically generated with darklua, it is not intended for manual editing.
--]]

local a a={cache={},load=function(b)if not a.cache[b]then a.cache[b]={c=a[b]()}
end return a.cache[b].c end}do function a.a()return 1 end function a.b()local b=
function(b)return game:GetService(b)end return{TweenService=(b'TweenService'),
RunService=(b'RunService'),UserInputService=(b'UserInputService'),Players=(b
'Players')}end function a.c()local b,c,d,e,f={},{},{},function(b,c,d)for e,f in
pairs(c)do local g=d for h in string.gmatch(f,'[^%.]+')do g=g and g[h]end if g~=
nil then pcall(function()b[e]=g end)end end end,function(b,c)for d,e in pairs(c)
do if d=='__marker'or d=='__themeKeys'then continue end if typeof(d)=='number'
then if typeof(e)=='Instance'then e.Parent=b elseif typeof(e)=='table'and e.
__marker then e.Parent=b end else pcall(function()b[d]=e end)end end end
function b.create(g)return function(h)h=h or{}local i,j=Instance.new(g),h.
__themeKeys if j then c[i]=j e(i,j,d)end f(i,h)local k={}k.__marker=true return
setmetatable(k,{__metatable=i,__tostring=function()return tostring(i)end,__index
=function(l,m)local n=i[m]if typeof(n)=='function'then return function(o,...)
return n(i,...)end else return n end end,__newindex=function(l,m,n)i[m]=n end})
end end function b.setTheme(g)d=g for h,i in pairs(c)do e(h,i,d)end end return b
end function a.d()local b={}b.protectGui=function(c)local d=cloneref and
cloneref(game)or game local e,f=pcall(function()c.Parent=gethui and gethui()or
cloneref and cloneref(d:GetService'CoreGui')or d:GetService'CoreGui'end)return e
and c or f end b.protectGui=newcclosure and newcclosure(b.protectGui)or b.
protectGui return b end function a.e()return function()local b,c,d,e,f=a.load'c'
.create,a.load'd',game:GetService'RunService',game:GetService'Players',{}f.
container=(b'ScreenGui'{Enabled=false,Name='Vanta',IgnoreGuiInset=true,
ResetOnSpawn=false,ScreenInsets=Enum.ScreenInsets.None,ZIndexBehavior=Enum.
ZIndexBehavior.Sibling,b'Frame'{Name='View',AnchorPoint=Vector2.new(0.5,0.5),
BorderColor3=Color3.fromRGB(0,0,0),BorderSizePixel=0,ClipsDescendants=true,
Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(600,450),__themeKeys={
BackgroundColor3='Background'},b'UICorner'{Name='UICorner',CornerRadius=UDim.
new(0,15)},b'Frame'{Name='Margins',AnchorPoint=Vector2.new(0.5,0.5),
BackgroundColor3=Color3.fromRGB(255,255,255),BackgroundTransparency=1,
BorderColor3=Color3.fromRGB(0,0,0),BorderSizePixel=0,Position=UDim2.fromScale(
0.5,0.5),Size=UDim2.new(1,-4,1,-4),b'UICorner'{Name='UICorner',CornerRadius=UDim
.new(0,13)},b'UIStroke'{Name='UIStroke',ApplyStrokeMode=Enum.ApplyStrokeMode.
Border,__themeKeys={Color='Border'}},b'UIPadding'{Name='UIPadding',PaddingBottom
=UDim.new(0,20),PaddingLeft=UDim.new(0,25),PaddingRight=UDim.new(0,25),
PaddingTop=UDim.new(0,20)},b'Frame'{Name='Topbar',AutomaticSize=Enum.
AutomaticSize.Y,BackgroundColor3=Color3.fromRGB(255,255,255),
BackgroundTransparency=1,BorderColor3=Color3.fromRGB(0,0,0),BorderSizePixel=0,
Size=UDim2.fromScale(1,0),b'UIListLayout'{Name='UIListLayout',FillDirection=Enum
.FillDirection.Horizontal,Padding=UDim.new(0,25),SortOrder=Enum.SortOrder.
LayoutOrder,VerticalAlignment=Enum.VerticalAlignment.Center},b'ImageLabel'{Name=
'Icon',BackgroundColor3=Color3.fromRGB(255,255,255),BackgroundTransparency=1,
BorderColor3=Color3.fromRGB(0,0,0),BorderSizePixel=0,ImageContent=Content.
fromAssetId(111377759265608),Size=UDim2.fromOffset(16,16),__themeKeys={
ImageColor3='Text.Quaternary'}},b'TextBox'{Name='CommandBar',AutomaticSize=Enum.
AutomaticSize.Y,BackgroundColor3=Color3.fromRGB(255,255,255),
BackgroundTransparency=1,BorderColor3=Color3.fromRGB(0,0,0),BorderSizePixel=0,
ClipsDescendants=true,CursorPosition=-1,FontFace=Font.new
'rbxassetid://12187365364',PlaceholderText='Enter a command...',Size=UDim2.new(1
,-25,0,0),Text='',TextSize=16,TextXAlignment=Enum.TextXAlignment.Left,
ClearTextOnFocus=false,__themeKeys={PlaceholderColor3='Text.Quaternary',
TextColor3='Text.Secondary'},b'UIPadding'{Name='UIPadding',PaddingBottom=UDim.
new(0,1),PaddingTop=UDim.new(0,1)}},b'UIPadding'{Name='UIPadding',PaddingBottom=
UDim.new(0,5)}},b'Frame'{Name='ContentDiv',AnchorPoint=Vector2.new(0.5,0),
BorderColor3=Color3.fromRGB(0,0,0),BorderSizePixel=0,Position=UDim2.fromScale(
0.5,0),Size=UDim2.new(1,30,0,1),__themeKeys={BackgroundColor3='Border'}},b
'UIListLayout'{Name='UIListLayout',HorizontalAlignment=Enum.HorizontalAlignment.
Center,Padding=UDim.new(0,15),SortOrder=Enum.SortOrder.LayoutOrder},b
'ScrollingFrame'{Name='Content',Active=true,BackgroundColor3=Color3.fromRGB(255,
255,255),BackgroundTransparency=1,BorderColor3=Color3.fromRGB(0,0,0),
BorderSizePixel=0,ScrollBarThickness=0,Selectable=false,Size=UDim2.new(1,30,1,-
58),AutomaticCanvasSize=Enum.AutomaticSize.XY,CanvasSize=UDim2.new(0,0,0,0),b
'UIListLayout'{Name='UIListLayout',HorizontalAlignment=Enum.HorizontalAlignment.
Center,Padding=UDim.new(0,5),SortOrder=Enum.SortOrder.LayoutOrder}}}}})f.view=(f
.container.View)f.margins=(f.view.Margins)f.content=(f.margins.Content)f.topbar=
(f.margins.Topbar)f.commandBar=(f.topbar.CommandBar)if d:IsStudio()then f.
container.Parent=e.LocalPlayer.PlayerGui else c.protectGui(f.container)end
return f end end function a.f()a.load'a'return function(b,c,d,e)local f,g=a.load
'c'.create,{}g.command=(f'TextButton'{Name='Command',AutoButtonColor=false,
AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,BorderColor3=Color3.
fromRGB(0,0,0),BorderSizePixel=0,Selectable=false,Size=UDim2.fromScale(1,0),Text
='',f'Frame'{Name='Icon',AnchorPoint=Vector2.new(0,0.5),BackgroundColor3=Color3.
fromRGB(255,255,255),BackgroundTransparency=1,BorderColor3=Color3.fromRGB(0,0,0)
,BorderSizePixel=0,Position=UDim2.fromScale(0,0.5),Size=UDim2.fromOffset(28,28),
f'ImageLabel'{Name='Image',AnchorPoint=Vector2.new(0.5,0.5),BackgroundColor3=
Color3.fromRGB(255,255,255),BackgroundTransparency=1,BorderColor3=Color3.
fromRGB(0,0,0),BorderSizePixel=0,ImageContent=Content.fromAssetId(d or
75764141026163),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(18,18),
__themeKeys={ImageColor3='Text.Secondary'}},f'UICorner'{Name='UICorner',
CornerRadius=UDim.new(0,5)}},f'UICorner'{Name='UICorner',CornerRadius=UDim.new(0
,7)},f'UIPadding'{Name='UIPadding',PaddingBottom=UDim.new(0,10),PaddingLeft=UDim
.new(0,10),PaddingRight=UDim.new(0,10),PaddingTop=UDim.new(0,10)},f'Frame'{Name=
'Info',AutomaticSize=Enum.AutomaticSize.XY,BackgroundColor3=Color3.fromRGB(255,
255,255),BackgroundTransparency=1,BorderColor3=Color3.fromRGB(0,0,0),
BorderSizePixel=0,LayoutOrder=1,f'TextLabel'{Name='Name',Active=true,
AutomaticSize=Enum.AutomaticSize.XY,BackgroundColor3=Color3.fromRGB(255,255,255)
,BackgroundTransparency=1,BorderColor3=Color3.fromRGB(0,0,0),BorderSizePixel=0,
FontFace=Font.new'rbxassetid://12187365364',LayoutOrder=1,Selectable=true,Text=b
or'',TextSize=15,TextXAlignment=Enum.TextXAlignment.Left,Visible=not not b,
__themeKeys={TextColor3='Text.Secondary'}},f'UIListLayout'{Name='UIListLayout',
Padding=UDim.new(0,5),SortOrder=Enum.SortOrder.LayoutOrder,VerticalAlignment=
Enum.VerticalAlignment.Center},f'TextLabel'{Name='Description',Active=true,
AutomaticSize=Enum.AutomaticSize.XY,BackgroundColor3=Color3.fromRGB(255,255,255)
,BackgroundTransparency=1,BorderColor3=Color3.fromRGB(0,0,0),BorderSizePixel=0,
FontFace=Font.new'rbxassetid://12187365364',LayoutOrder=1,Selectable=true,Text=c
or'',TextSize=14,TextXAlignment=Enum.TextXAlignment.Left,Visible=not not c,
__themeKeys={TextColor3='Text.Tertiary'}}},f'UIListLayout'{Name='UIListLayout',
FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,10),SortOrder=
Enum.SortOrder.LayoutOrder,VerticalAlignment=Enum.VerticalAlignment.Center},f
'Folder'{Name='Arguments',f'UIListLayout'{Name='UIListLayout',
HorizontalAlignment=Enum.HorizontalAlignment.Right,Padding=UDim.new(0,5),
SortOrder=Enum.SortOrder.LayoutOrder}}})g.arguments=(g.command.Arguments)g.info=
(g.command.Info)g.name=(g.info:FindFirstChild'Name')g.description=(g.info.
Description)g.icon=(g.command.Icon)g.image=(g.icon.Image)g.updateArguments=
function(h)for i,j in next,(h or{})do f'TextLabel'{Name='Argument',Active=true,
AnchorPoint=Vector2.new(1,0),AutomaticSize=Enum.AutomaticSize.XY,
BackgroundColor3=Color3.fromRGB(255,255,255),BackgroundTransparency=1,
BorderColor3=Color3.fromRGB(0,0,0),BorderSizePixel=0,FontFace=Font.new
'rbxassetid://16658246179',LayoutOrder=1,Position=UDim2.fromScale(1,0),RichText=
true,Selectable=true,Text=`{j.Name}{j.Optional and'?'or''}: {j.Type}`,TextSize=
13,TextXAlignment=Enum.TextXAlignment.Left,Parent=g.arguments,__themeKeys={
TextColor3='Text.Secondary'}}end end g.updateArguments(e)return g end end
function a.g()return{Accent=Color3.fromRGB(100,100,100),Background=Color3.
fromRGB(25,25,25),Border=Color3.fromRGB(55,55,55),Text={Primary=Color3.fromRGB(
255,255,255),Secondary=Color3.fromRGB(200,200,200),Tertiary=Color3.fromRGB(160,
160,160),Quaternary=Color3.fromRGB(115,115,115),Quinary=Color3.fromRGB(0,0,0),
Senary=Color3.fromRGB(215,215,215)}}end function a.h()return{Accent=Color3.
fromRGB(140,103,78),Background=Color3.fromRGB(25,23,21),Border=Color3.fromRGB(55
,54,52),Text={Primary=Color3.fromRGB(255,255,255),Secondary=Color3.fromRGB(200,
200,200),Tertiary=Color3.fromRGB(160,160,160),Quaternary=Color3.fromRGB(115,115,
115),Quinary=Color3.fromRGB(0,0,0),Senary=Color3.fromRGB(215,215,215)}}end
function a.i()return{Accent=Color3.fromRGB(180,145,70),Background=Color3.
fromRGB(28,26,21),Border=Color3.fromRGB(60,56,48),Text={Primary=Color3.fromRGB(
255,255,255),Secondary=Color3.fromRGB(200,200,200),Tertiary=Color3.fromRGB(160,
160,160),Quaternary=Color3.fromRGB(115,115,115),Quinary=Color3.fromRGB(0,0,0),
Senary=Color3.fromRGB(215,215,215)}}end function a.j()return{Accent=Color3.
fromRGB(80,140,90),Background=Color3.fromRGB(23,27,24),Border=Color3.fromRGB(52,
59,54),Text={Primary=Color3.fromRGB(255,255,255),Secondary=Color3.fromRGB(200,
200,200),Tertiary=Color3.fromRGB(160,160,160),Quaternary=Color3.fromRGB(115,115,
115),Quinary=Color3.fromRGB(0,0,0),Senary=Color3.fromRGB(215,215,215)}}end
function a.k()return{Accent=Color3.fromRGB(60,120,180),Background=Color3.
fromRGB(22,26,30),Border=Color3.fromRGB(50,56,64),Text={Primary=Color3.fromRGB(
255,255,255),Secondary=Color3.fromRGB(200,200,200),Tertiary=Color3.fromRGB(160,
160,160),Quaternary=Color3.fromRGB(115,115,115),Quinary=Color3.fromRGB(0,0,0),
Senary=Color3.fromRGB(215,215,215)}}end function a.l()return{Accent=Color3.
fromRGB(130,90,160),Background=Color3.fromRGB(26,23,29),Border=Color3.fromRGB(56
,51,61),Text={Primary=Color3.fromRGB(255,255,255),Secondary=Color3.fromRGB(200,
200,200),Tertiary=Color3.fromRGB(160,160,160),Quaternary=Color3.fromRGB(115,115,
115),Quinary=Color3.fromRGB(0,0,0),Senary=Color3.fromRGB(215,215,215)}}end end
local b,c,d,e,f=a.load'a',a.load'b',a.load'c',a.load'e',a.load'f'local g,h,i,j,k
,l,m=c.RunService,c.UserInputService,false,{},{},{Themes={Monochrome=a.load'g',
Peach=a.load'h',Gold=a.load'i',Forest=a.load'j',Sapphire=a.load'k',Royal=a.load
'l'}}function l:callback(n,...)assert(typeof(n)=='function',debug.traceback(`'callback' expects type 'function' for Argument #1, got '{
typeof(n)}'`,2))task.spawn(function(...)local o,p=pcall(n,...)if not o then task
.defer(warn,debug.traceback(p,2))end end,...)end local n=function()if not m then
return end local n=l.container.commandBar.Text:split' 'table.remove(n,1)local o=
{}for p,q in ipairs(n)do local r if q=='true'then r=true elseif q=='false'then r
=false elseif q=='nil'then r=nil else local s=tonumber(q)if s then r=s else r=q
end end o[p]=r end local p=m.properties.Arguments and#m.properties.Arguments l:
callback(m.properties.Callback,m.properties,unpack(o,1,p))end l.Initialize=
function(o)local p,q,r={Theme={},Position=o and o.Position or UDim2.fromScale(
0.5,0.5),AnchorPoint=o and o.AnchorPoint or Vector2.new(0.5,0.5),Shortcut=o and
o.Shortcut or{Enum.KeyCode.F2}},l.Themes.Peach,o and o.Theme or{}p.Theme.Accent=
r.Accent or q.Accent p.Theme.Background=r.Background or q.Background p.Theme.
Border=r.Border or q.Border p.Theme.Text={}local s,t=r.Text or{},q.Text p.Theme.
Text.Primary=s.Primary or t.Primary p.Theme.Text.Secondary=s.Secondary or t.
Secondary p.Theme.Text.Tertiary=s.Tertiary or t.Tertiary p.Theme.Text.Quaternary
=s.Quaternary or t.Quaternary p.Theme.Text.Quinary=s.Quinary or t.Quinary p.
Theme.Text.Senary=s.Senary or t.Senary d.setTheme(p.Theme)l.container=e()l.
container.view.AnchorPoint=p.AnchorPoint l.container.view.Position=p.Position
local u,v=function()l.container.container.Enabled=false l.container.commandBar:
ReleaseFocus()end,function(u)if m then m.command.name.TextColor3=p.Theme.Text.
Secondary m.command.description.TextColor3=p.Theme.Text.Tertiary m.command.
command.BackgroundColor3=p.Theme.Text.Primary m.command.command.
BackgroundTransparency=1 m.command.icon.BackgroundTransparency=1 m.command.image
.ImageColor3=p.Theme.Text.Primary for v,w in pairs(m.command.arguments:
GetChildren())do if w:IsA'TextLabel'then w.TextColor3=p.Theme.Text.Secondary end
end end if not u then return end m=u u.command.name.TextColor3=p.Theme.Text.
Primary u.command.description.TextColor3=p.Theme.Text.Senary u.command.command.
BackgroundColor3=p.Theme.Accent u.command.command.BackgroundTransparency=0 u.
command.icon.BackgroundTransparency=0 u.command.image.ImageColor3=p.Theme.Text.
Quinary for v,w in pairs(u.command.arguments:GetChildren())do if w:IsA
'TextLabel'then w.TextColor3=p.Theme.Text.Primary end end end h.InputBegan:
Connect(function(w,x)if not l.container.container.Enabled then return end if w.
KeyCode==Enum.KeyCode.Escape then u()return end if w.UserInputType==Enum.
UserInputType.MouseButton1 then local y,z=w.Position,l.container.view local A,B=
z.AbsolutePosition,z.AbsoluteSize local C=y.X>=A.X and y.X<=A.X+B.X and y.Y>=A.Y
and y.Y<=A.Y+B.Y if not C then u()end return end if w.KeyCode==Enum.KeyCode.Down
then if#k==0 then return end local y=m and table.find(k,m)or 0 if y then local z
=(y%#k)+1 v(k[z])i=true l.container.commandBar.Text=k[z].properties.Name l.
container.commandBar.CursorPosition=#l.container.commandBar.Text+1 local A,B=k[z
].command.command,l.container.content local C=A.AbsolutePosition.Y local D,E=C+A
.AbsoluteSize.Y,B.AbsolutePosition.Y local F=E+B.AbsoluteWindowSize.Y if C<E
then B.CanvasPosition=Vector2.new(0,B.CanvasPosition.Y-(E-C))elseif D>F then B.
CanvasPosition=Vector2.new(0,B.CanvasPosition.Y+(D-F))end end return elseif w.
KeyCode==Enum.KeyCode.Up then if#k==0 then return end local y=m and table.find(k
,m)or 0 if y then local z=y-1 if z<1 then z=#k end v(k[z])i=true l.container.
commandBar.Text=k[z].properties.Name l.container.commandBar.CursorPosition=#l.
container.commandBar.Text+1 local A,B=k[z].command.command,l.container.content
local C=A.AbsolutePosition.Y local D,E=C+A.AbsoluteSize.Y,B.AbsolutePosition.Y
local F=E+B.AbsoluteWindowSize.Y if C<E then B.CanvasPosition=Vector2.new(0,B.
CanvasPosition.Y-(E-C))elseif D>F then B.CanvasPosition=Vector2.new(0,B.
CanvasPosition.Y+(D-F))end end return end return end)l.container.commandBar.
FocusLost:Connect(function(w)if w then if m and#k~=0 then local x,y,z=l.
container.commandBar.Text:lower():split' '[1]or'',m for A,B in ipairs(k)do if B.
properties.Name:lower()==x then z=B break end if B.properties.Aliases then for C
,D in ipairs(B.properties.Aliases)do if D:lower()==x then z=B break end end if z
then break end end end if z then y=z end m=y n()end u()return end if l.container
.container.Enabled then l.container.commandBar:CaptureFocus()end end)l.container
.commandBar:GetPropertyChangedSignal'Text':Connect(function()if i then i=false
return end local w=l.container.commandBar.Text:lower():split' '[1]or''k={}for x,
y in ipairs(j)do local z,A=y.properties.Name:lower():find(w,1,true)==1,false if
not z and y.properties.Aliases then for B,C in ipairs(y.properties.Aliases)do if
C:lower():find(w,1,true)==1 then A=true break end end end local B=w==''or z or A
y.command.command.Visible=B if B then table.insert(k,y)end end if w~=''then
local x,y={},w:lower()for z,A in ipairs(k)do local B,C=(A.properties.Name:lower(
))if B==y then C=0 else C=#B end table.insert(x,{command=A,score=C})end table.
sort(x,function(z,A)return z.score<A.score end)k={}for z,A in ipairs(x)do table.
insert(k,A.command)end end if#k>0 then v(k[1])else v(nil)end end)do local w=
false g.RenderStepped:Connect(function()local x,y=#p.Shortcut,0 for z,A in
pairs(p.Shortcut)do if h:IsKeyDown(A)then y+=1 end end if not w and y==x then w=
true l.container.container.Enabled=not l.container.container.Enabled if l.
container.container.Enabled then l.container.commandBar:CaptureFocus()else l.
container.commandBar:ReleaseFocus()end elseif y<x then w=false end end)end local
w={Register=function(w)w=w or{}local x,y=f(w.Name or'Command',w.Description or
'Description',w.Icon or 75764141026163,w.Arguments or{}),{}setmetatable(y,{
__index=w,__newindex=function(z,A,B)if A=='Name'then x.name.Text=B elseif A==
'Description'then x.description.Text=B elseif A=='Icon'then x.image=Content.
fromAssetId(B)elseif A=='Arguments'then x.updateArguments(B)end w[A]=B end})if w
.Name and w.Name:find' 'then error
"vanta.Register: property 'Name' cannot contain spaces"end x.command.Parent=l.
container.content x.command.MouseEnter:Connect(function()if not m or(m and m.
command~=x)then x.command.BackgroundTransparency=0.95 x.icon.
BackgroundTransparency=0.95 end end)x.command.MouseLeave:Connect(function()if
not m or(m and m.command~=x)then x.command.BackgroundTransparency=1 x.icon.
BackgroundTransparency=1 end end)x.command.MouseButton1Click:Connect(function()v
{command=x,properties=y}n()u()end)table.insert(j,{command=x,properties=y})table.
insert(k,{command=x,properties=y})return y end}for x,y in pairs(w)do l.container
[x]=y end setmetatable(l.container,{__newindex=function(x,y,z)if y=='Theme'and
type(z)=='table'then p.Theme=z d.setTheme(z)elseif y=='Position'and typeof(z)==
'UDim2'then p.Position=z l.container.view.Position=z elseif y=='AnchorPoint'and
typeof(z)=='Vector2'then p.AnchorPoint=z l.container.view.AnchorPoint=z elseif y
=='Shortcut'and type(z)=='table'then p.Shortcut=z else rawset(l.container,y,z)
end end,__index=function(x,y)return w[y]or rawget(l.container,y)end})return l.
container end return l
