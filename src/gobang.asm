.386
.model flat,stdcall
option casemap:none

ExitProcess PROTO, dwExitCode : DWORD

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; include �ļ�����
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
include	windows.inc
include	kernel32.inc
includelib	kernel32.lib
include	gdi32.inc
includelib	gdi32.lib
include	msimg32.inc
includelib	msimg32.lib
include	user32.inc
includelib	user32.lib
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;	Equ ��ֵ����
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
AI_GAME			equ		1000
TWOMEN_GAME		equ		1001
BAT_AI			equ		1002
BAT_TWO			equ		1003
BLACK_CHESS		equ		1004
WHITE_CHESS		equ		1005
BOARD			equ		1006

CHESSCLASS	struct
	isWhite		DWORD	?	;	1 for white, 2 for black, 0 for none
	others		DWORD	?
CHESSCLASS	ends

; ����״̬�ṹ��
Impetus STRUCT
    ais     DWORD  ? 
    dis     DWORD  ?  
    aoh     DWORD  ? 
    arh     DWORD  ?
	aov     DWORD  ?
	alh     DWORD  ?
	doh     DWORD  ? 
    drh     DWORD  ?
	dov     DWORD  ?
	dlh     DWORD  ?
Impetus ENDS                

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; ���ݶ�
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
.data
;**************�߼�
board           DWORD    225    DUP(-1) ; ���� ************* Ϊ�˸�������Ч���������߼�,���߼��������µ�����洢
state           DWORD    10     DUP(0) ; �м�̬����
ais				DWORD    ? 
dis				DWORD    ?  
aoh				DWORD    ? 
arh				DWORD    ?
aov				DWORD    ?
alh				DWORD    ?
doh				DWORD    ? 
drh				DWORD    ?
dov				DWORD    ?
dlh				DWORD    ?

temp_x			DWORD    ?
temp_y			DWORD    ?
;***********����
hInstance	DWORD	?
hWinMain	DWORD	?
stChessBoard	CHESSCLASS	225	dup	(<0,?>)
;###################################################################
;�ӿڹ���ȫ�ֱ���
dwPlayerColor	DWORD	0		;	�˻���ս�������ִ������ɫ	;*******Ĭ�ϳ�ʼִ��Ϊ��
dwIPlayerColor	DWORD	0		;	˫�˶�ս����� I ��������ɫ******����ִ����
dwChessColor	DWORD	0		;	˫�˶�ս�е�ǰ������ɫ	;*******������Ӻ��޸ı���, ����ʱֱ�Ӷ�ȡ
dwPosX		DWORD	?
dwPosY		DWORD	?
dwPosXc		DWORD	0
dwPosYc		DWORD	0
dwWinFlag	DWORD	0		;	Ĭ��ʤ��δ��
dwWinner	DWORD	?
dwChessVis	DWORD	1		;	�˻���ս��,��ǰ���������Ƿ�Ҫ��
dwNewGame	DWORD	0		;	�Ƿ�ʼ��һ��
;####################################################################
;Ӯ�ּ�¼
dwPlayerWin	DWORD	0
dwIPlayerWin	DWORD	0
dwNumGame	DWORD	?		;	��ǰ�����
dwCurrGame	DWORD	?		;	��ǰģʽ --> 0 for AI, 1 for twomen


	.const
;���ƺ������ò���
MAX DWORD 2147483647
MIN DWORD -2147483647
DE_QUAR DWORD 2000000
DOUBLE_QUAR DWORD 1900000
SINGLEL_QUAR DWORD 1800000
QUAR_TRI DWORD 1700000
DE_TRI DWORD 11000
SINGLED_QUAR DWORD 55
SINGLEL_TRI DWORD 50
SINGLED_TRI DWORD 30

hint1 BYTE 'Please input an integer as x:',0
hint2 BYTE 'Please input another integer as y:',0

deltaX dword 0,-1,-1,-1,0,1,1,1,0,-2,-2,-2,0,2,2,2, 0,-3,-3,-3,0,3,3,3,0,-4,-4,-4,0,4,4,4,0,-5,-5,-5,0,5,5,5
deltaY dword 1,1,0,-1,-1,-1,0,1,2,2,0,-2,-2,-2,0,2, 3,3,0,-3,-3,-3,0,3,4,4,0,-4,-4,-4,0,4, 5,5,0,-5,-5,-5,0,5
depth  dword 7

directionX dword 1,0,-1,0,1,1,-1,-1
directionY dword 0,1,0,-1,1,-1,1,-1

; ������ֵ
szClassName		BYTE	'GobangClass',0
szWindowName	BYTE	'��������',0
szGameOver		BYTE	'��Ϸ����!',0
szGameChange	BYTE	'ģʽ�ı�',0
szAIModel		BYTE	'�����˻�ģʽ',0
szTwoMenModel	BYTE	'����˫��ģʽ',0

szGameNum1		BYTE	'��1��',0
szGameNum2		BYTE	'��2��',0
szGameNum3		BYTE	'��3��',0
szGameNum4		BYTE	'��4��',0
szGameNum5		BYTE	'��5��',0
szGameNum6		BYTE	'��6��',0

szPlayerWin		BYTE	'��һ�ʤ',0
szAIWin			BYTE	'���Ի�ʤ',0
szIPlayerWin	BYTE	'���I��ʤ',0
szIIPlayerWin	BYTE	'���II��ʤ',0

szFiPlayerWin	BYTE	'��Ϸ�ս�, ��һ�ʤ!',0
szFiAIWin	BYTE	'��Ϸ�ս�, ���Ի�ʤ!',0
szFiEqu			BYTE	'��Ϸ�ս�, ƽ��!',0
szFiIPlayerWin	BYTE	'��Ϸ�ս�, ���I��ʤ!',0
szFiIIPlayerWin	BYTE	'��Ϸ�ս�, ���II��ʤ!',0

ErrorTitle		BYTE	'Error chess judge',0
FontName		BYTE	'lyf',0
BLACK_COLOR		DWORD		0
WHITE_COLOR		DWORD		0FFFFFFh
BLUE_COLOR		DWORD		0FF0000h
NUM_GAME		DWORD		6

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; �����
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	.code
;---------------------------------------------
;	�ڲ��߼���
;---------------------------------------------
;�����жϺ���
a_directional_search PROC uses ebx ecx edx esi edi, color:DWORD, x:DWORD, y:DWORD, hstep:DWORD, vstep:DWORD, add_sum:DWORD
	;//��������
	;memset(st, 0, sizeof(st));
	;int cnt = 1;
	;int tx = x + hstep;
	;int ty = y + vstep;
	local @st0, @st1, @st2, @st3, @st4, @st5, @st6, conn, tx,ty:DWORD 
	mov @st0, 0
	mov @st1, 0
	mov @st2, 0
	mov @st3, 0
	mov @st4, 0
	mov @st5, 0
	mov @st6, 0
	mov ebx, 1
	mov ecx, x
	mov tx, ecx
	mov ecx, hstep
	add tx, ecx
	mov ecx, y
	mov ty, ecx
	mov ecx, vstep
	add ty, ecx

	.while (ebx <= 5)
		.if (tx < 0 || tx >= 15 || ty < 0 || ty >= 15)
			;st[4] = 1;
			mov @st4, 1
			.break
		.else 
			mov eax, tx
			mov edi, 15
			mul edi
			add eax, ty
			mov esi, OFFSET board
			mov edi, [esi+eax*4]
			; ;mWriteInt edi
			.if (edi == -1)
				.break
			.elseif (edi != color)
				;st[4] = 1;
				mov @st4, 1
				.break
			.endif
		.endif
		;cnt++;
		add ebx, 1
		;tx += hstep; ty += vstep;
		mov ecx, hstep
		add tx, ecx
		mov ecx, vstep
		add ty, ecx
	.endw
	; ;mWriteInt ebx
	;st[3] += cnt;
	add @st3, ebx
	;tx += hstep; ty += vstep;
	mov ecx, hstep
	add tx, ecx
	mov ecx, vstep
	add ty, ecx

	.if (@st4 == 0)
		;conn = 0;
		mov conn, 0
		.while (ebx <= 5)
			.if (tx < 0 || tx >= 15 || ty < 0 || ty >= 15) 
				;st[6] = 1;
				mov @st6, 1
				.break
			.else 
				mov eax, tx
				mov edi, 15
				mul edi
				add eax, ty
				mov esi, OFFSET board
				mov edi, [esi+eax*4]
				.if (edi == -1)
					.break
				.elseif (edi != color)
					;st[6] = 1;
					mov @st6, 1
					.break
				.endif
			.endif
			;cnt++; conn++;
			;tx += hstep; ty += vstep;
			add ebx, 1
			add conn, 1
			mov ecx, hstep
			add tx, ecx
			mov ecx, vstep
			add ty, ecx
		.endw

		;st[5] = conn;
		mov eax, conn
		mov @st5, eax
		.if (ebx == 6)
			;st[6] = 1;
			mov @st6, 1 
		.endif
	.endif

	;//��������
	;cnt = 1;
	;tx = x - hstep;
	;ty = y - vstep;
	;conn = 0;
	mov ebx, 1
	mov ecx, x
	mov tx, ecx
	mov ecx, hstep
	sub tx, ecx
	mov ecx, y
	mov ty, ecx
	mov ecx, vstep
	sub ty, ecx

	.while (ebx <= 5)
		.if (tx < 0 || tx >= 15 || ty < 0 || ty >= 15) 
			;st[2] = 1;
			mov @st2, 1
			.break
		.else
			mov eax, tx
			mov edi, 15
			mul edi
			add eax, ty
			mov esi, OFFSET board
			mov edi, [esi+eax*4]		
			.if (edi == -1)
				.break
			.elseif (edi != color)
				;st[2] = 1;
				mov @st2, 1
				.break
			.endif
		.endif
		;cnt++;
		;tx -= hstep; ty -= vstep;
		add ebx, 1
		mov ecx, hstep
		sub tx, ecx
		mov ecx, vstep
		sub ty, ecx
	.endw

	;st[3] += cnt - 1;
	add @st3, ebx
	sub @st3, 1
	;tx -= hstep; ty -= vstep;
	mov ecx, hstep
	sub tx, ecx
	mov ecx, vstep
	sub ty, ecx	

	.if (@st2 == 0)
		mov conn, 0
		.while (ebx <= 5)
			.if (tx < 0 || tx >= 15 || ty < 0 || ty >= 15) 
				;st[0] = 1;
				mov @st0, 1
				.break
			.else
				mov eax, tx
				mov edi, 15
				mul edi
				add eax, ty
				mov esi, OFFSET board
				mov edi, [esi+eax*4]
				.if (edi == -1)
					.break
				.elseif (edi != color)
					;st[0] = 1;
					mov @st0, 1
					.break
				.endif
			.endif
			;cnt++; conn++;
			;tx -= hstep; ty -= vstep;
			add ebx, 1
			add conn, 1
			mov ecx, hstep
			sub tx, ecx
			mov ecx, vstep
			sub ty, ecx
		.endw
		;st[1] = conn;
		mov eax, conn
		mov @st1, eax
		.if (ebx == 6)
			;st[0] = 1;
			mov @st0, 1
		.endif
	.endif
	;//��������
	 ;*sum += (st[3] - 1) * 3;
	 mov eax, @st3
	 sub eax, 1
	 mov edi, 3
	 mul edi
	 add ais, eax

	 .if (@st2 == 0)
		  ;*sum += 1 + st[1] * 2;
		  add eax, @st1
		  mov edi, 2
		  mul edi
		  add eax, 1
		  add ais, eax
	 .endif
	 .if (@st4 == 0)
		  ;*sum += 1 + st[5] * 2;
		  add eax, @st5
		  mov edi, 2
		  mul edi
		  add eax, 1
		  add ais, eax
	 .endif

	;//for (int i = 0; i <= 6; i++)printf("%d ", st[i]); printf("\n");
	;//�����ж�
	.if (@st3 > 5)
		;return 1;//����
		mov eax, 1
		ret
	.elseif (@st3 == 5) 
		;return 2;//����
		mov eax, 2
		ret
	.elseif (@st3 == 4)
		.if (@st2 == 0 && @st4 == 0) 
			;return 3; //����
			mov eax, 3
			ret
		.elseif (@st2 == 0 || @st4 == 0) 
			;return 4; //����
			mov eax, 4
			ret
		.else 
			;return 5; //����
			mov eax, 5
			ret
		.endif
	.elseif (@st3 == 3)
		.if (@st2 == 1 && @st4 == 1)
			;return 9;
			mov eax, 9
			ret
		.elseif (@st2 == 0 && @st4 == 0) 
			.if (@st1 == 1 || @st5 == 1)
				.if (@st1 == 1 && @st5 == 1)
					;return 6;
					mov eax, 6
					ret
				.elseif (@st1 >= 1 && @st5 >= 1 && color == 0) 
					;return 6;
					mov eax, 6
					ret
				.else 
					;return 4;
					mov eax, 4
					ret
				.endif
			.elseif (@st1 > 1 || @st5 > 1)
				.if (@st1 > 1 && @st5 > 1)
					.if (color == 0)
						;return 6;
						mov eax, 6
						ret
					.else 
						;return 9;
						mov eax, 9
						ret
					.endif
				.else
					.if (color == 0)
						;return 4;
						mov eax, 4
						ret
					.endif
					.if (@st1 > 1)
						.if (@st6 == 0)
							;return 8;
							mov eax, 8
							ret
						.else 
							;return 7;
							mov eax, 7
							ret
						.endif 
					.else 
						.if (@st0 == 0)
							;return 8; 
							mov eax, 8
							ret
						.else 
							;return 7;
							mov eax, 7
							ret
						.endif
					.endif
				.endif
			.else 
				.if (@st0 == 1 && @st6 == 1)
					;return 8;
					mov eax, 8
					ret
				.else 
					;return 7;
					mov eax, 7
					ret
				.endif
			.endif
		.else 
			.if (@st2 == 1) 
				.if (@st5 > 1) 
					.if (color == 0)
						;return 4; 
						mov eax, 4
						ret
					.else 
						;return 9;
						mov eax, 9
						ret
					.endif
				.elseif (@st5 == 1) 
					;return 4;
					mov eax, 4
					ret
				.else 
					.if (@st6 == 1)
						;return 9;
						mov eax, 9
						ret
					.else 
						;return 8;
						mov eax, 8
						ret
					.endif
				.endif
			.else 
				.if (@st1 > 1)
					.if (color == 0)
						;return 4;
						mov eax, 4
						ret
					.else 
						;return 9;
						mov eax, 9
						ret
					.endif
				.elseif (@st1 == 1) 
					;return 4;
					mov eax, 4
					ret
				.else 
					.if (@st0 == 1)
						;return 9;
						mov eax, 9
						ret
					.else 
						;return 8;
						mov eax, 8
						ret
					.endif
				.endif
			.endif
		.endif
	.elseif (@st3 == 2)
		.if (@st2 == 1 && @st4 == 1) 
			;return 0;
			mov eax, 0
			ret
		.elseif (@st2 == 0 && @st4 == 0) 
			.if (@st1 == 2 || @st5 == 2)
				.if (@st1 == 2 && @st5 == 2)
					;return 6;
					mov eax, 6
					ret
				.elseif (@st1 >= 2 && @st5 >= 2 && color == 0) 
					;return 6;
					mov eax, 6
					ret
				.else 
					;return 4;
					mov eax, 4
					ret
				.endif
			.elseif (@st1 > 2 || @st5 > 2)
				.if (@st1 > 2 && @st5 > 2)
					.if (color == 0)
						;return 6;
						mov eax, 6
						ret
					.else 
						;return 0;
						mov eax, 0
						ret
					.endif
				.else
					.if (color == 0) 
						;return 4;
						mov eax, 4
						ret
					.else 
						.if (@st1 > 2) 
							.if (@st5 == 1 && @st6 == 0)
								;return 8;
								mov eax, 8
								ret
							.else 
								;return 0;
								mov eax, 0
								ret
							.endif
						.else 
							.if (@st1 == 1 && @st0 == 0)
								;return 8;
								mov eax, 8
								ret
							.else 
								;return 0;
								mov eax, 0
								ret
							.endif
						.endif
					.endif
				.endif
			.else 
				.if (@st1 == 0 && @st5 == 0)
					;return 0;
					mov eax, 0
					ret
				.elseif(@st1 == 1 || @st5 == 1)
					.if (@st1 == 1 && @st0 == 0)
						;return 7;
						mov eax, 7
						ret
					.elseif (@st5 == 1 && @st6 == 0)
						;return 7;
						mov eax, 7
						ret
					.else 
						;return 8;
						mov eax, 8
						ret
					.endif
				.else 
					.if (color == 0)
						;return 7;
						mov eax, 7
						ret
					.else 
						.if (@st0 == 1 && @st6 == 1)
							;return 9;
							mov eax, 9
							ret
						.else 
							;return 7;
							mov eax, 7
							ret
						.endif
					.endif
				.endif
			.endif
		.else 
			.if (@st2 == 1) 
				.if (@st5 > 2) 
					.if (color == 0)
						;return 4;
						mov eax, 4
						ret
					.else 
						;return 0;
						mov eax, 0
						ret
					.endif
				.elseif (@st5 == 2) 
					;return 4;
					mov eax, 4
					ret
				.elseif (@st5 == 1)
					.if (@st6 == 1)
						;return 9;
						mov eax, 9
						ret
					.else 
						;return 8;
						mov eax, 8
						ret
					.endif
				.else 
					;return 0;
					mov eax, 0
					ret
				.endif
			.else 
				.if (@st1 > 2) 
					.if (color == 0)
						;return 4;
						mov eax, 4
						ret
					.else 
						;return 9;
						mov eax, 9
						ret
					.endif
				.elseif (@st1 == 2) 
					;return 4;
					mov eax, 4
					ret
				.elseif (@st1 == 1) 
					.if (@st0 == 1)
						;return 9;
						mov eax, 9
						ret
					.else 
						;return 8;
						mov eax, 8
						ret
					.endif
				.else 
					;return 0;
					mov eax, 0
					ret
				.endif
			.endif
		.endif
	.else 
		.if (@st2 == 1 && @st4 == 1)
			;return 0;
			mov eax, 0
			ret
		.elseif (@st2 == 0 && @st4 == 0)
			.if (@st1 == 3 || @st5 == 3) 
				.if (@st1 == 3 && @st5 == 3)
					;return 6;
					mov eax, 6
					ret
				.elseif (@st1 >= 3 && @st5 >= 3 && color == 0) 
					;return 6;
					mov eax, 6
					ret
				.else 
					;return 4;
					mov eax, 4
					ret
				.endif
			.elseif (@st1 > 3 || @st5 > 3)
				.if (@st1 > 3 && @st5 > 3)
					.if (color == 0)
						;return 6;
						mov eax, 6
						ret
					.else 
						;return 0;
						mov eax, 0
						ret
					.endif
				.else
					.if (color == 0) 
						;return 4;
						mov eax, 4
						ret
					.else 
						.if (@st1 > 3) 
							.if (@st5 == 2 && @st6 == 0)
								;return 8;
								mov eax, 8
								ret
							.else 
								;return 0;
								mov eax, 0
								ret
							.endif
						.else 
							.if (@st1 == 2 && @st0 == 0)
								;return 8;
								mov eax, 8
								ret
							.else 
								;return 0;
								mov eax, 0
								ret
							.endif
						.endif
					.endif
				.endif
			.else 
				.if (@st1 == 2 || @st5 == 2)
					.if (@st1 == 2 && @st5 == 2) 
						.if (color == 0) 
							.if (@st0 == 1 && @st6 == 1)
								;return 8;
								mov eax, 8
								ret
							.else 
								;return 7;
								mov eax, 7
								ret
							.endif
						.else 
							.if (@st0 == 0 && @st6 == 0)
								;return 7;
								mov eax, 7
								ret
							.elseif (@st0 == 1 && @st6 == 1)
								;return 9;
								mov eax, 9
								ret
							.else 
								;return 8;
								mov eax, 8
								ret
							.endif
						.endif
					.elseif (@st1 == 2) 
						.if (@st0 == 0)
							;return 7;
							mov eax, 7
							ret
						.else 
							;return 8;
							mov eax, 8
							ret
						.endif
					.else
						.if (@st5 == 0)
							;return 7;
							mov eax, 7
							ret
						.else 
							;return 8;
							mov eax, 8
							ret
						.endif
					.endif
				.else 
					;return 0;
				.endif
			.endif
		.else
			.if (@st2 == 1)
				.if (@st5 > 3)
					.if (color == 0)
						;return 4;
						mov eax, 4
						ret
					.else 
						;return 0;
						mov eax, 0
						ret
					.endif
				.elseif (@st5 == 3)
					;return 4;
					mov eax, 4
					ret
				.elseif (@st5 == 2)
					.if (@st6 == 1)
						;return 9;
						mov eax, 9
						ret
					.else 
						;return 8;
						mov eax, 8
						ret
					.endif
				.else 
					;return 0;
					mov eax, 0
					ret
				.endif
			.else 
				.if (@st1 > 3)
					.if (color == 0)
						;return 4;
						mov eax, 4
						ret
					.else 
						;return 0;
						mov eax, 0
						ret
					.endif
				.elseif (@st1 == 3)
					;return 4;
					mov eax, 4
					ret
				.elseif (@st1 == 2)
					.if (@st0 == 1)
						;return 9;
						mov eax, 9
						ret
					.else 
						;return 8;
						mov eax, 8
						ret
					.endif
				.else 
					;return 0;
					mov eax, 0
					ret
				.endif
			.endif
		.endif
	.endif
	;return 0;
	mov eax, 0
	ret
a_directional_search ENDP

;�����жϺ���
d_directional_search PROC uses ebx ecx edx esi edi, color:DWORD, x:DWORD, y:DWORD, hstep:DWORD, vstep:DWORD,add_sum:DWORD
	;memset(st, 0, sizeof(st));
	local @st0, @st1, @st2, @st3, @st4, @st5, @st6, tx, ty:DWORD 
	mov @st0, 0
	mov @st1, 0
	mov @st2, 0
	mov @st3, 0
	mov @st4, 0
	mov @st5, 0
	mov @st6, 0
	;int cnt = 1;
	mov ebx, 1
	;int tx = x + hstep;
	mov ecx, x
	mov tx, ecx
	mov ecx, hstep
	add tx, ecx
	mov ecx, y
	mov ty, ecx
	mov ecx, vstep
	add ty, ecx

	.while (ebx <= 5)
		.if (tx < 0 || tx >= 15 || ty < 0 || ty >= 15)
			mov @st3, 1
			.break
		.else
			mov eax, tx
			mov edi, 15
			mul edi
			add eax, ty
			mov esi, OFFSET board
			mov edi, [esi+eax*4]

			.if(edi == -1)
				.break
			.elseif(edi == color)
				mov @st3, 1
				.break
			.endif
		.endif
		;cnt++;
		add ebx, 1
		;tx += hstep; ty += vstep;
		mov ecx, hstep
		add tx, ecx
		mov ecx, vstep
		add ty, ecx
	.endw
	;st[2] = cnt - 1;
	mov @st2, ebx
	sub @st2, 1

	;cnt = 1;
	mov ebx, 1
	;tx = x - hstep;
	mov ecx, x
	mov tx, ecx
	mov ecx, hstep
	sub tx, ecx
	mov ecx, y
	mov ty, ecx
	mov ecx, vstep
	sub ty, ecx

	.while (ebx <= 5)
		.if (tx < 0 || tx >= 15 || ty < 0 || ty >= 15) 
			mov @st0, 1
			.break
		.else
			mov eax, tx
			mov edi, 15
			mul edi
			add eax, ty
			mov esi, OFFSET board
			mov edi, [esi+eax*4]

			.if (edi == -1)
				.break
			.elseif (edi == color)
				mov @st0, 1
				.break
			.endif
		.endif
		;cnt++;
		add ebx, 1
		;tx -= hstep; ty -= vstep;
		mov ecx, hstep
		sub tx, ecx
		mov ecx, vstep
		sub ty, ecx
	.endw
	;st[1] = cnt - 1;
	mov @st1, ebx
	sub @st1, 1

	;int obs = st[1] + st[2];
	;printf("%d\n", obs);
	mov ebx, @st1
	add ebx, @st2

	;*sum += obs * 2;
	; ;mWriteInt ebx;
	mov eax, ebx
	mov edi, 5
	mul edi
	add dis, eax

	.if (ebx > 4)
		.if (color == 0)
			;return 2;
			mov eax, 2
			ret
		.else 
			;return 1;
			mov eax, 1
			ret
		.endif
	.elseif (ebx == 4)
		;return 1;
		mov eax, 1
		ret
	.elseif (ebx == 3)
		.if (@st1 == 3)
			.if (@st0 == 1)
				;return 0; 
				mov eax, 0
				ret
			.else 
				;return 3;
				mov eax, 3
				ret
			.endif
		.elseif (@st2 == 3)
			.if (@st3 == 1)
				;return 0;
				mov eax, 0
				ret
			.else 
				;return 3;
				mov eax, 3
				ret
			.endif
		.else
			.if (@st0 == 1 || @st3 == 1)
				;return 0; 
				mov eax, 0
				ret
			.else 
				;return 3;
				mov eax, 3
				ret
			.endif
		.endif
	.else
		;return 0;
		mov eax, 0
		ret
	.endif
	ret
d_directional_search ENDP

; ͳ�����Ƹ�������1
judge_impetus PROC uses ebx ecx edx, x:DWORD, flag:DWORD
	.if (flag == 0)
		mov eax,aoh
		mov ebx,arh
		mov ecx,aov
		mov edx,alh
		.if((eax == x)||(ebx == x)||(ecx == x)||(edx == x))
			mov eax, 1
			ret
		.else
			mov eax, 0
			ret
		.endif
	.else
		mov eax,doh
		mov ebx,drh
		mov ecx,dov
		mov edx,dlh
		.if((eax == x)||(ebx == x)||(ecx == x)||(edx == x))
			mov eax, 1
			ret
		.else
			mov eax, 0
			ret
		.endif
	.endif
	ret
judge_impetus ENDP

; ͳ�����Ƹ�������2
cnt_impetus PROC uses ebx ecx edx esi, x:DWORD, flag:DWORD, s:DWORD
	mov esi, 0

	.if (flag == 0) 
		mov eax,aoh
		mov ebx,arh
		mov ecx,aov
		mov edx,alh
		.if (eax == x)
			add esi,s
		.endif
		.if (ebx == x)
			add esi,s
		.endif
		.if (ecx == x)
			add esi,s
		.endif
		.if (edx == x)
			add esi,s
		.endif
	.else 
		mov eax,doh
		mov ebx,drh
		mov ecx,dov
		mov edx,dlh
		.if (eax == x)
			add esi,s
		.endif
		.if (ebx == x)
			add esi,s
		.endif
		.if (ecx == x)
			add esi,s
		.endif
		.if (edx == x)
			add esi,s
		.endif
	.endif
	
	mov eax, esi
	ret
cnt_impetus ENDP

;�������жϺ���
check_impetus PROC uses ebx ecx edx esi edi, color:DWORD, x:DWORD, y:DWORD
	local summ:DWORD

	;imp->ais = 0;
	mov ais, 0
	;imp->aoh = a_directional_search(c, x, y, 0, 1, &imp->ais);
	INVOKE a_directional_search, color, x, y, 0, 1, addr ais
	mov aoh, eax
	;call WriteInt
	
	;imp->arh = a_directional_search(c, x, y, 1, 1, &imp->ais);
	INVOKE a_directional_search, color, x, y, 1, 1, addr ais
	mov arh, eax
	;call WriteInt
	
	;imp->aov = a_directional_search(c, x, y, 1, 0, &imp->ais);
	INVOKE a_directional_search, color, x, y, 1, 0, addr ais
	mov aov, eax
	;call WriteInt
	
	;imp->alh = a_directional_search(c, x, y, 1, -1, &imp->ais);
	INVOKE a_directional_search, color, x, y, 1, -1, addr ais
	mov alh, eax
	;call WriteInt
	
	;imp->dis = 0;
	mov dis, 0
	;imp->doh = d_directional_search(c, x, y, 0, 1, &imp->dis);
	INVOKE d_directional_search, color, x, y, 0, 1, addr dis
	;call WriteInt
	mov doh, eax
	;imp->drh = d_directional_search(c, x, y, 1, 1, &imp->dis);
	INVOKE d_directional_search, color, x, y, 1, 1, addr dis
	;call WriteInt
	mov drh, eax
	;imp->dov = d_directional_search(c, x, y, 1, 0, &imp->dis);
	INVOKE d_directional_search, color, x, y, 1, 0, addr dis
	;call WriteInt
	mov dov, eax
	;imp->dlh = d_directional_search(c, x, y, 1, -1, &imp->dis);
	INVOKE d_directional_search, color, x, y, 1, -1, addr dis
	;call WriteInt
;	;call Crlf
	mov dlh, eax

	;printf("%d %d %d %d\n%d %d %d %d\n", imp->aoh, imp->arh, imp->aov, imp->alh, imp->doh, imp->drh, imp->dov, imp->dlh);
	;int tril_cnt = 0;
	mov ebx, 0
	;int trid_cnt = 0;
	mov ecx, 0
	;int trif_cnt = 0;
	mov edi, 0
	;int quar_cnt = 0;
	mov esi, 0

	;quar_cnt = cnt_impetus(3, 0, 1, imp);
	INVOKE cnt_impetus, 3, 0, 1
	add esi, eax
	;quar_cnt += cnt_impetus(4, 0, 1, imp);
	INVOKE cnt_impetus, 4, 0, 1
	add esi, eax
	;quar_cnt += cnt_impetus(6, 0, 2, imp);
	INVOKE cnt_impetus, 6, 0, 2
	add esi, eax
	;tril_cnt = cnt_impetus(7, 0, 1, imp);
	INVOKE cnt_impetus, 7, 0, 1
	add ebx, eax
	;trid_cnt = cnt_impetus(3, 1, 1, imp);
	INVOKE cnt_impetus, 3, 1, 1
	add ecx, eax
	;trif_cnt = cnt_impetus(9, 0, 1, imp);
	INVOKE cnt_impetus, 9, 0, 1
	add edi, eax

	;int ret = 0;
	.if (color == 0)
		;if (judge_impetus(1, 0, imp)||judge_impetus(2, 0, imp))return MIN;
		INVOKE judge_impetus, 1, 0
		.if(eax == 1)
			mov eax, MIN
			ret
		.endif
		INVOKE judge_impetus, 2, 0
		.if(eax == 1)
			mov eax, MIN
			ret
		.endif
		;if (judge_impetus(1, 1, imp)) return (-1) * DE_QUAR;
		INVOKE judge_impetus, 1, 1
		.if(eax == 1)
			mov eax, 0
			sub eax, DE_QUAR
			ret
		.endif
		;if (quar_cnt >= 2) return (-1) * DOUBLE_QUAR;
		.if(esi >= 2)
			mov eax, 0
			sub eax, DOUBLE_QUAR
			ret
		.endif
		;if (judge_impetus(3, 0, imp))return (-1) * SINGLEL_QUAR;
		INVOKE judge_impetus, 3, 0
		.if(eax == 1)
			mov eax, 0
			sub eax, SINGLEL_QUAR
			ret
		.endif
		;if (quar_cnt >= 1 && tril_cnt >= 1)return (-1) * QUAR_TRI;
		.if(esi >= 1 && ebx >= 1)
			mov eax, 0
			sub eax, QUAR_TRI
			ret
		.endif

		;ret = trid_cnt * DE_TRI + quar_cnt * SINGLED_QUAR + tril_cnt * SINGLEL_TRI + trif_cnt * SINGLED_TRI;
		;ret += imp->ais + imp->dis;
		mov summ, 0
		mov eax, ecx
		mul DE_TRI
		add summ, eax
		mov eax, esi
		mul SINGLED_QUAR
		add summ, eax
		mov eax, ebx
		mul SINGLEL_TRI
		add summ, eax
		mov eax, edi
		mul SINGLED_TRI
		add summ, eax
		mov eax, ais
		add summ, eax
		mov eax,dis
		add summ, eax
		;if (judge_impetus(2, 1, imp))ret -= 10;
		INVOKE judge_impetus, 2, 1
		.if(eax == 1)
			sub summ, 10
		.endif
		;return (-1) * ret;
		mov eax, 0
		sub eax, summ
		ret
	.else
		;if (judge_impetus(2, 0, imp))return MAX;
		INVOKE judge_impetus, 2, 0
		.if(eax == 1)
			mov eax, MAX
			ret
		.endif
		;if (judge_impetus(1, 0, imp))return MIN;
		INVOKE judge_impetus, 1, 0
		.if(eax == 1)
			mov eax, MIN
			ret
		.endif
		;if (tril_cnt >= 2 || quar_cnt >= 2)return MIN;
		.if(ebx >= 2 || esi >= 2)
			mov eax, MIN
			ret
		.endif

		;if (judge_impetus(1, 1, imp)) return DE_QUAR;
		INVOKE judge_impetus, 1, 1
		.if(eax == 1)
			mov eax, DE_QUAR
			ret
		.endif
		;if (judge_impetus(3, 0, imp)) return SINGLEL_QUAR;
		INVOKE judge_impetus, 3, 0
		.if(eax == 1)
			mov eax, SINGLEL_QUAR
			ret
		.endif 
		;if (quar_cnt >= 1 && tril_cnt >= 1)return QUAR_TRI;
		.if(ebx >= 1 && esi >= 1)
			mov eax, QUAR_TRI
			ret
		.endif

		;ret = trid_cnt * DE_TRI + quar_cnt * SINGLED_QUAR + tril_cnt * SINGLEL_TRI + trif_cnt * SINGLED_TRI;
		mov summ, 0
		mov eax, ecx
		mul DE_TRI
		add summ, eax
		mov eax, esi
		mul SINGLED_QUAR
		add summ, eax
		mov eax, ebx
		mul SINGLEL_TRI
		add summ, eax
		mov eax, edi
		mul SINGLED_TRI
		add summ, eax
		mov eax, ais
		add summ, eax
		mov eax,dis
		add summ, eax
		
		;return ret;
		mov eax, summ
		ret
	.endif
check_impetus ENDP

isAround PROC uses ebx ecx edx edi esi, x:dword,y:dword 
; for (int i = 0; i < 8; i++) {
;  int tr = r + fx[i];
;  int tc = c + fy[i];
;  if (tr >= 0 && tr < 15 && tc >= 0 && tc < 15 && board[tr][tc] != -1)return true;
; }return false;
 
 mov ebx, 0
 .while (ebx < 8)
  mov esi, OFFSET directionX
  mov edi, [esi+ebx*4]
  mov ecx, x
  add ecx, edi
  mov esi, OFFSET directionY
  mov edi, [esi+ebx*4]
  mov edx, y
  add edx, edi

  mov esi, OFFSET board
  mov eax, [esi+448]
  ;mWriteInt eax
  .if (ecx >= 0 && ecx < 15 && edx >= 0 && edx < 15 )
   mov eax, ecx
   mov esi, edx
   mov edi, 15
   mul edi
   add eax, esi
   mov esi, OFFSET board

   mov edi, [esi+eax*4]
   .if (edi != -1)
    mov eax,1
    ret
   .endif
  .endif
  
  inc ebx
 .endw
 mov eax,-1
 ret

isAround ENDP
alphabeta PROC uses ebx ecx edx edi esi,alpha:sdword, beta:sdword, color:dword, dep:dword, x:dword,y:dword
	local @tx:dword, @ty:dword, @evalue:sdword, @v:sdword, @cur:dword

	.if(dep==0)
		mov eax, 1
		sub eax, color
		invoke check_impetus, eax, x,y
		ret
	.endif

	mov ebx,0
	.while (ebx < 40)
;		mWriteInt ebx 

		mov edi, [offset deltaX+ebx*4]
		mov esi, x
		add esi, edi
		mov @tx, esi
		mov edi, [offset deltaY+ebx*4]
		mov esi, y
		add esi, edi
		mov @ty, esi

		.if (@tx<0 || @ty<0 || @tx>=15 ||@ty >=15)
			Inc ebx
			.continue
		.endif
		;mWriteInt board[112]
		invoke isAround, @tx,@ty

		mov ecx, eax
		mov eax, @tx
		mov edi, 15
		mul edi
		add eax, @ty
		mov esi, offset board
		mov edi, [esi+eax*4]
		.if (edi!=-1 || ecx==-1)
			Inc ebx
			.continue
		.endif
		invoke check_impetus, color, @tx, @ty

		mov @evalue, eax
		mov eax, 10000
		mov edi,-10000
		.if (@evalue < eax) && (@evalue > edi)
			mov eax, @tx
			mov edi, 15
			mul edi
			add eax, @ty
			mov esi, offset board
			mov edi, color
			mov [esi+eax*4], edi
			mov eax, 1
			sub eax, color
			mov edx, dep
			sub edx, 1


			;mov @cur, ebx
			invoke alphabeta, alpha, beta, eax, edx, @tx, @ty

			mov @v,eax
			mov eax, @tx
			mov edi, 15
			mul edi
			add eax, @ty
			mov esi, offset board
			mov edi, -1
			mov [esi+eax*4], edi
		.else
			mov ecx, @evalue
			mov @v, ecx
		.endif
		.if(!color)
		;mWriteInt ebx
			mov edi, @v
			.if(edi < beta)
				mov edi, @v
				mov beta, edi
				mov edi, dep
				.if edi == depth
					mov edi, @tx
					mov dwPosXc, edi
					mov edi, @ty
					mov dwPosYc, edi
				.endif
			.endif
		.endif
		.if(color)
			mov edi, @v
			.if(edi > alpha)
				mov edi, @v
				mov alpha, edi
				mov edi, dep
				.if edi == depth
					mov edi, @tx
					mov dwPosXc, edi
					mov edi, @ty
					mov dwPosYc, edi
				.endif
			.endif
		.endif

		mov edi, beta
		.if (edi <= alpha)
			.break
		.endif
		add ebx,1
	.endw

	mov edx,dep
	.if(edx==depth)
	invoke check_impetus,color,dwPosXc,dwPosYc
	.if eax==MAX
		mov dwWinFlag,1
		mov dwWinner,1
		mov dwChessVis,1
	.elseif eax==MIN
		mov dwWinFlag,1
		mov dwWinner,0
		mov dwChessVis,1
	.else
		mov dwWinFlag,0
		mov dwChessVis,1
	.endif
		mov eax, dwPosXc
		mov edi, 15
		mul edi
		add eax, dwPosYc
		mov esi, OFFSET board
		mov ecx,color
		mov [esi+eax*TYPE DWORD], ecx

	.endif
	.if(color)
		mov eax, alpha
		ret
	.else
		mov eax, beta
		ret
	.endif
alphabeta ENDP

_BoardInitial	proc uses eax ecx esi edi
	local	@row, @col
	;***************
	mov		@row, 0
	mov		@col, 0
	.while @row < 15
		mov	@col, 0
		.while @col < 15
			; ��������λ��
			mov esi, OFFSET board
			mov eax, @row
			mov edi, 15
			mul edi
			add eax, @col
			mov	ecx, -1
			mov [esi+eax*4], ecx
			;@col ++
			mov	eax, @col
			inc	eax
			mov	@col, eax
		.endw
		; @row ++
		mov	eax, @row
		inc	eax
		mov	@row, eax
	.endw
ret
_BoardInitial	endp

_SetLogicChess PROC uses eax ebx ecx edx esi edi, color:DWORD, x:DWORD, y:DWORD
	mov esi, OFFSET board
	mov eax, x
	mov edi, 15
	mul edi
	add eax, y
	mov ebx, color
	mov [esi+eax*4], ebx
	ret
_SetLogicChess ENDP

_IdiotPlay	proc uses ebx ecx edx esi edi
	.if	dwNewGame == 1
		mov	dwNewGame, 0
		invoke _BoardInitial
	.endif
	;�������
	INVOKE _SetLogicChess, dwPlayerColor, dwPosX, dwPosY
	;�ж���Ϸ�Ƿ��Ѿ�����
	INVOKE check_impetus, dwPlayerColor, dwPosX, dwPosY
	.if (eax == MAX)
		mov dwWinFlag, 1
		mov dwWinner, 1
		mov dwChessVis, 0
		ret
	.elseif (eax == MIN)
		mov dwWinFlag, 1
		mov dwWinner, 0
		mov dwChessVis, 0
		ret
	.else
		mov edx, 1
		sub edx, dwPlayerColor
		INVOKE alphabeta, MIN, MAX,edx, depth, dwPosX, dwPosY
		ret
	.endif
_IdiotPlay	endp

_WinCheck PROC uses ebx ecx edx esi edi
	.if	dwNewGame == 1
		mov	dwNewGame, 0
		invoke _BoardInitial
	.endif
	;����(Ĭ���Ѿ��ж���������)
	invoke _SetLogicChess, dwChessColor, dwPosX, dwPosY
	;�ж�ʤ��
	invoke check_impetus, dwChessColor, dwPosX, dwPosY

	.if	eax == MIN
		mov	dwWinFlag, 1
		mov	dwWinner, 0
	.elseif eax == MAX
		mov	dwWinFlag, 1
		mov	dwWinner, 1
	.else
		mov	dwWinFlag, 0
	.endif
ret
_WinCheck	ENDP
;----------------------------------------------
;	������
;----------------------------------------------
_CheckCorrect proc	uses edi ebx ecx, _row:DWORD, _col:DWORD
	local	@addr

	mov	eax, _row
	mov	ecx, 15
	mul	ecx
	mov	ebx, _col
	add	eax, ebx
	mov	@addr, eax
	;***************
	mov	edi, offset stChessBoard
	mov	eax, @addr
	mov	ecx, sizeof CHESSCLASS
	mul	ecx
	add	edi, eax
	.if [edi + CHESSCLASS.isWhite] == 0
		mov	eax, 0
	.else
		mov	eax, 1
	.endif
	ret
_CheckCorrect	endp
_PutChess	proc uses ebx edi eax ecx, _row:DWORD, _col:DWORD, _color:DWORD
	local	@addr
	mov	eax, _row
	mov	ecx, 15
	mul	ecx
	mov	ebx, _col
	add	eax, ebx
	mov	@addr, eax
	;***************
	mov	edi, offset stChessBoard
	mov	eax, @addr
	mov	ecx, sizeof CHESSCLASS
	mul	ecx
	add	edi, eax
	mov	eax, _color
	mov	[edi + CHESSCLASS.isWhite], eax
ret
_PutChess	endp
;*****************������ֵ��ʼ��
_InitialVal	proc uses edi eax ecx
	local	@row, @col, @addr
	;***************set stChessBoard to 0
	mov		@row, 0
	mov		@col, 0
	.while @row < 15
		mov	@col, 0
		.while @col < 15
			; ��������λ��
			mov	eax, @row
			mov	ecx, 15
			mul	ecx
			mov	ebx, @col
			add	eax, ebx
			mov	@addr, eax
			;**************
			mov	edi, offset stChessBoard
			mov	eax, @addr
			mov	ecx, sizeof CHESSCLASS
			mul	ecx
			add	edi, eax
			mov	eax, 0
			mov	[edi + CHESSCLASS.isWhite], eax
			;@col ++
			mov	eax, @col
			inc	eax
			mov	@col, eax
		.endw
		; @row ++
		mov	eax, @row
		inc	eax
		mov	@row, eax
	.endw
	;***************stChessBoard
	mov	edi, offset stChessBoard
	mov	eax, sizeof CHESSCLASS
	mov	ecx, 112
	mul	ecx
	add	edi, eax
	mov	[edi+CHESSCLASS.isWhite], 2
	ret
_InitialVal	endp
;*****************������Ϸ����
_NextGame	proc
	invoke	_InitialVal
	mov	eax, dwNumGame
	add eax, 1
	mov	dwNumGame, eax
	mov	dwNewGame, 1
	.if	dwCurrGame == 0
		xor	dwPlayerColor, 1
		.if	dwPlayerColor == 1
			mov	dwPosX, 7
			mov	dwPosY, 7
			invoke	_IdiotPlay
			invoke	_PutChess, dwPosXc, dwPosYc, 1
		.else	; �����ִ��ʱ,��������,����_WinCheckʵ�ֳ�ʼ��
			mov	dwChessColor,1
			mov	dwPosX, 7
			mov	dwPosY, 7
			invoke	_WinCheck
		.endif
	.elseif	dwCurrGame == 1
		xor	dwIPlayerColor, 1
		mov	dwChessColor, 1
		mov	dwPosX, 7
		mov	dwPosY, 7
		invoke	_WinCheck
	.endif
ret
_NextGame	endp
_RestartGame	proc
	invoke	_InitialVal
	mov	dwNumGame, 1
	mov	dwNewGame, 1
	.if	dwCurrGame == 0
		mov	dwPlayerWin, 0
		mov	dwPlayerColor, 0
	.elseif dwCurrGame == 1
		mov	dwChessColor, 1
		mov	dwIPlayerWin, 0
		mov	dwIPlayerColor, 1
		mov	dwPosX, 7
		mov	dwPosY, 7
		invoke	_WinCheck
	.endif
ret
_RestartGame	endp
;*****************��������
_InBoard	proc uses edi eax ebx ecx, _hWnd, _posX:WORD, _posY:WORD
	local	@col, @row, @isCorrect, @uMsg, @tmp

	mov	ax, _posX
	sub	ax, 60
	mov	cl, 42
	idiv	cl
	movzx	ebx, al
	cmp		ah, 20
	jng		@@jump1
	inc		ebx
@@jump1:
	mov	@col, ebx
	mov	dwPosY, ebx
	;**************************
	mov	ax, _posY
	sub	ax, 40
	idiv	cl
	movzx	ebx, al
	cmp	ah,20
	jng	@@jump2
	inc	ebx
@@jump2:
	mov	@row, ebx
	mov	dwPosX, ebx
	;**************************
	invoke	_CheckCorrect, @row, @col
	mov	@isCorrect, eax
	.if	@isCorrect != 0	; 0 for correct, because 0 means no chess
		jmp	@@exit
	.else
	;*****************************
		.if	dwCurrGame == 0
			mov	eax, dwPlayerColor
			add	eax, 1
			invoke	_PutChess, @row, @col, eax
			;*********�����ػ�**********
			invoke	InvalidateRect, _hWnd, NULL, FALSE
			;@@@@@@@@@@���û�������
			invoke	_IdiotPlay
			.if	dwWinFlag == 1	;��Ϸ����
				mov	eax, dwWinner
				.if	dwPlayerColor == eax
					invoke MessageBox,NULL, addr szPlayerWin, addr szGameOver, MB_OK
					mov	eax,	dwPlayerWin
					add	eax,	1
					mov	dwPlayerWin,	eax
					invoke	_NextGame
				.else
					invoke MessageBox,NULL, addr szAIWin, addr szGameOver, MB_OK
					invoke	_NextGame
				.endif
				.if dwNumGame == 7
					.if	dwPlayerWin >= 4
						invoke MessageBox,NULL, addr szFiPlayerWin, addr szGameOver, MB_OK
					.elseif	dwPlayerWin == 3
						invoke MessageBox,NULL, addr szFiEqu, addr szGameOver, MB_OK
					.else
						invoke MessageBox,NULL, addr szFiAIWin, addr szGameOver, MB_OK
					.endif
					invoke	_RestartGame
				.endif
				invoke	InvalidateRect, _hWnd, NULL, FALSE
			.elseif	dwChessVis == 1
				.if	dwPlayerColor == 0
					invoke	_PutChess, dwPosXc, dwPosYc, 2
				.elseif dwPlayerColor == 1
					invoke	_PutChess, dwPosXc, dwPosYc, 1
				.endif
				invoke	InvalidateRect, _hWnd, NULL, FALSE
			.endif
		;************************
		.elseif dwCurrGame == 1
			mov	eax, dwChessColor
			xor	eax,1
			mov	dwChessColor, eax
			add eax, 1
			invoke	_PutChess, @row, @col, eax
			;************�����ػ�
			invoke	InvalidateRect, _hWnd, NULL, FALSE

			invoke _WinCheck
			;*************WinJudge
			.if	dwWinFlag == 1
				mov	eax, dwIPlayerColor
				.if	dwChessColor == eax
					invoke MessageBox,NULL, addr szIPlayerWin, addr szGameOver, MB_OK
					mov	eax, dwIPlayerWin
					add	eax, 1
					mov	dwIPlayerWin, eax
					invoke	_NextGame
				.else
					invoke MessageBox,NULL, addr szIIPlayerWin, addr szGameOver, MB_OK
					invoke	_NextGame
				.endif
				.if dwNumGame == 7
					.if	dwIPlayerWin >= 4
						invoke MessageBox,NULL, addr szFiIPlayerWin, addr szGameOver, MB_OK
					.elseif	dwIPlayerWin == 3
						invoke MessageBox,NULL, addr szFiEqu, addr szGameOver, MB_OK
					.else
						invoke MessageBox,NULL, addr szFiIIPlayerWin, addr szGameOver, MB_OK
					.endif
					invoke	_RestartGame
				.endif
				invoke	InvalidateRect, _hWnd, NULL, FALSE
			.endif
		.endif
	.endif
@@exit:
	ret
_InBoard	endp
;*********����ȫͼ
_DrawBmp	proc	_hdcWnd:DWORD, _hdcLoadBmp:DWORD, _hbmp:DWORD, _posX:DWORD, _posY:DWORD, _scaleX:DWORD, _scaleY:DWORD
	invoke	SelectObject, _hdcLoadBmp, _hbmp
	invoke	BitBlt, _hdcWnd, _posX, _posY, _scaleX, _scaleY,\
					_hdcLoadBmp, 0, 0, SRCCOPY
	ret
_DrawBmp	endp
;*********����͸��ͼ
_DrawTransparentBmp	proc	_hdcWnd:DWORD, _hdcLoadBmp:DWORD, _hbmp:DWORD, _xDest:DWORD, _yDest:DWORD, _nDestWidth:DWORD, _nDestHeight:DWORD,_nSrcWidth:DWORD, _nSrcHeight:DWORD, _crTransparent:DWORD
	invoke	SelectObject, _hdcLoadBmp, _hbmp
	invoke	TransparentBlt, _hdcWnd, _xDest, _yDest, _nDestWidth, _nDestHeight,\
						_hdcLoadBmp, 0, 0, _nSrcWidth, _nSrcHeight, _crTransparent
	ret
_DrawTransparentBmp	endp
;**********��������
_DrawBoard	proc	uses ecx eax ,_hdcWnd:DWORD, _hPen:DWORD
	local	@row, @tmpX, @tmpY

	invoke	SelectObject, _hdcWnd, _hPen
	mov		@row, 0
	.while	@row < 15
	; ��-- ���
		mov		eax, @row
		mov		ecx, 42
		mul		ecx
		add		eax, 40
		mov		@tmpY, eax
		invoke	MoveToEx, _hdcWnd, 60, @tmpY, NULL
	; ��-- �յ�
		mov		eax, 14
		mov		ecx, 42
		mul		ecx
		add		eax, 60
		mov		@tmpX, eax
		invoke	LineTo, _hdcWnd, @tmpX, @tmpY
	; ��--- ���
		mov		eax, @row
		mov		ecx, 42
		mul		ecx
		add		eax, 60
		mov		@tmpX, eax
		invoke	MoveToEx, _hdcWnd, @tmpX, 40, NULL
	; ��--- �յ�
		mov		eax, 15
		mov		ecx, 42
		mul		ecx
		mov		@tmpY, eax
		invoke	LineTo, _hdcWnd, @tmpX, @tmpY
	;*************************
		mov		eax, @row
		inc		eax
		mov		@row, eax
	.endw
	ret
_DrawBoard	endp
;**********��������
_DrawChess	proc	uses ebx ecx eax edi, _hdcWnd:DWORD, _hdcLoadBmp:DWORD, _hWhiteChess:DWORD, _hBlackChess:DWORD
	local	@row, @col, @tmpX, @tmpY, @addr

	mov		@row, 0
	mov		@col, 0
	.while @row < 15
		mov	@col, 0
		.while @col < 15
			; ��������λ��
			mov	eax, @row
			mov	ecx, 15
			mul	ecx
			mov	ebx, @col
			add	eax, ebx
			mov	@addr, eax
			;**************
			mov	edi, offset stChessBoard
			mov	eax, @addr
			mov	ecx, sizeof CHESSCLASS
			mul	ecx
			add	edi, eax
			;************
		; ����Ҫ����
			.if	[edi + CHESSCLASS.isWhite] != 0
				mov	eax, @col
				mov	ecx, 42
				mul	ecx
				mov	ebx, 40
				add	eax, ebx
				mov	@tmpX, eax
				;**************
				mov	eax, @row
				mul	ecx
				add	eax, 20
				mov	@tmpY, eax
				;**************��ͼ
				.if [edi + CHESSCLASS.isWhite] == 1
					invoke	_DrawTransparentBmp, _hdcWnd, _hdcLoadBmp, _hWhiteChess, @tmpX, @tmpY, 40, 40, 40, 40, BLUE_COLOR
				.elseif	[edi + CHESSCLASS.isWhite] == 2
					invoke	_DrawTransparentBmp, _hdcWnd, _hdcLoadBmp, _hBlackChess, @tmpX, @tmpY, 40, 40, 40, 40, BLUE_COLOR
				.else
					invoke MessageBox,NULL, addr ErrorTitle, addr ErrorTitle, MB_ICONERROR+MB_OK
				.endif
			.endif
			;@col ++
			mov	eax, @col
			inc	eax
			mov	@col, eax
		.endw
		; @row ++
		mov	eax, @row
		inc	eax
		mov	@row, eax
	.endw
	ret
_DrawChess	endp
;**********���Ʋ����
_DrawBtn	proc	_hdcWnd:DWORD, _hdcLoadBmp:DWORD, _hAIGame:DWORD, _hTwoMenGame:DWORD, _hBatAI:DWORD, _hBatTwo:DWORD, _hWhiteChess:DWORD, _hBlackChess:DWORD, _hFont:DWORD
	local	@posX, @posY

	mov	@posX, 725
	mov	@posY, 80
	.if	dwCurrGame == 0 ;****AI
		invoke	_DrawBmp, _hdcWnd, _hdcLoadBmp, _hAIGame, @posX, @posY, 200, 70
		;********************
		mov	@posX, 805
		mov	@posY, 210
		.if	dwPlayerColor == 0
			invoke	_DrawTransparentBmp, _hdcWnd, _hdcLoadBmp, _hWhiteChess, @posX, @posY, 40, 40, 40, 40, BLUE_COLOR
		.elseif dwPlayerColor == 1
			invoke	_DrawTransparentBmp, _hdcWnd, _hdcLoadBmp, _hBlackChess, @posX, @posY, 40, 40, 40, 40, BLUE_COLOR
		.endif
		;************
	.elseif dwCurrGame == 1
		invoke	_DrawBmp, _hdcWnd, _hdcLoadBmp, _hTwoMenGame, @posX, @posY, 200, 70
		;***************
		mov	@posX, 805
		mov	@posY, 210
		.if	dwChessColor == 1	; ��һ��Ϊ��,����Ϊ��
			invoke	_DrawTransparentBmp, _hdcWnd, _hdcLoadBmp, _hWhiteChess, @posX, @posY, 40, 40, 40, 40, BLUE_COLOR
		.elseif dwPlayerColor == 0
			invoke	_DrawTransparentBmp, _hdcWnd, _hdcLoadBmp, _hBlackChess, @posX, @posY, 40, 40, 40, 40, BLUE_COLOR
		.endif
		;**************
	.endif
	;********************************************
	mov	@posX, 725
	mov	@posY, 280
	.if	dwNumGame == 1
		invoke	TextOut, _hdcWnd, @posX, @posY, addr szGameNum1, sizeof szGameNum1
	.elseif dwNumGame == 2
		invoke	TextOut, _hdcWnd, @posX, @posY, addr szGameNum2, sizeof szGameNum2
	.elseif	dwNumGame == 3
		invoke	TextOut, _hdcWnd, @posX, @posY, addr szGameNum3, sizeof szGameNum3
	.elseif	dwNumGame == 4
		invoke	TextOut, _hdcWnd, @posX, @posY, addr szGameNum4, sizeof szGameNum4
	.elseif	dwNumGame == 5
		invoke	TextOut, _hdcWnd, @posX, @posY, addr szGameNum5, sizeof szGameNum5
	.elseif	dwNumGame == 6
		invoke	TextOut, _hdcWnd, @posX, @posY, addr szGameNum6, sizeof szGameNum6
	.endif
	;********************************************
	mov	@posX, 725
	mov	@posY, 440
	invoke	_DrawBmp, _hdcWnd, _hdcLoadBmp, _hBatAI, @posX, @posY, 200, 70
	;********************************************
	mov	@posX, 725
	mov	@posY, 550
	invoke	_DrawBmp, _hdcWnd, _hdcLoadBmp, _hBatTwo, @posX, @posY, 200, 70

	ret
_DrawBtn	endp
;**********��Ӧ�����, �޸�һЩ����ֵ
_RespMouse	proc	uses eax ecx, _hWnd:DWORD, _posX:WORD, _posY:WORD
	.if	_posX >= 40 && _posX <= 660 && _posY >= 20 && _posY <= 640
		invoke	_InBoard, _hWnd, _posX, _posY
		;*************************
	.elseif _posX >= 725 && _posX <= 925 && _posY >= 440 && _posY <= 510
		invoke MessageBox, NULL, addr szAIModel, addr szGameChange, MB_OK
		mov	dwCurrGame, 0
		invoke	_RestartGame
		invoke	InvalidateRect, _hWnd, NULL, FALSE
		;*************************
	.elseif	_posX >= 725 && _posX <= 925 && _posY >= 550 && _posY <= 620
		invoke MessageBox, NULL, addr szTwoMenModel, addr szGameChange, MB_OK
		mov	dwCurrGame, 1
		invoke	_RestartGame
		invoke	InvalidateRect, _hWnd, NULL, FALSE
	.endif
	ret
_RespMouse	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>
;	���ڹ���
;>>>>>>>>>>>>>>>>>>>>>>>>>>>
_ProcWinMain	proc	uses ebx edi esi, hWnd, uMsg, wParam, lParam
	local	@stPs:PAINTSTRUCT
	local	@stRect:RECT
	local	@hdcLoadBmp, @hdcMemBuffer, @hdcWindow
	local	@blankBmp, @hBoard, @hWhiteChess, @hBlackChess
	local	@hPen, @hFont
	local	@hAIGame, @hTwoMenGame, @hBatAI, @hBatTwo
	local	@posX:WORD, @posY:WORD

	mov	eax, uMsg
	mov	ecx, hWnd
;*****************************************
	.if	eax == WM_PAINT
		;****************************************
		invoke	BeginPaint, hWnd, addr @stPs
		mov		@hdcWindow,	eax
        invoke	GetClientRect, hWnd, addr @stRect
		invoke	CreateCompatibleDC,	@hdcWindow
		; ������ʱ�ж�, eax--> 0
		mov		@hdcMemBuffer,	eax
		invoke	CreateCompatibleDC,	@hdcWindow
		mov		@hdcLoadBmp,	eax
		invoke	CreateCompatibleBitmap, @hdcWindow, 1000, 700
		mov		@blankBmp,	eax
		invoke	SelectObject,@hdcMemBuffer,@blankBmp
;*****************************************************Board
		invoke	LoadBitmap, hInstance, BOARD
		mov		@hBoard,	eax
		invoke	_DrawBmp, @hdcMemBuffer, @hdcLoadBmp, @hBoard, 0, 0,1000, 700
	;************************************************Pen
		invoke	CreatePen, PS_SOLID, 1, BLACK_COLOR
		mov		@hPen,	eax
		invoke	_DrawBoard, @hdcMemBuffer, @hPen
	;************************************************Chess
		invoke	LoadBitmap, hInstance, WHITE_CHESS
		mov		@hWhiteChess,	eax
		invoke	LoadBitmap, hInstance, BLACK_CHESS
		mov		@hBlackChess,	eax
		invoke	_DrawChess,	@hdcMemBuffer, @hdcLoadBmp, @hWhiteChess, @hBlackChess
	;************************************************Button
		invoke	LoadBitmap, hInstance, AI_GAME
		mov		@hAIGame,	eax
		invoke	LoadBitmap, hInstance, TWOMEN_GAME
		mov		@hTwoMenGame, eax
		invoke	LoadBitmap, hInstance, BAT_AI
		mov		@hBatAI,	eax
		invoke	LoadBitmap, hInstance, BAT_TWO
		mov		@hBatTwo,	eax
		invoke	CreateFont, 60, 0, 0, 0,700, 0, 0, 0,OEM_CHARSET,\
							OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS,\
							DEFAULT_QUALITY, DEFAULT_PITCH or FF_SCRIPT,\
							addr FontName
		invoke	SelectObject, @hdcMemBuffer, eax
		mov		@hFont, eax
		invoke	SetTextColor, @hdcMemBuffer, 0h
		invoke	_DrawBtn, @hdcMemBuffer, @hdcLoadBmp, @hAIGame, @hTwoMenGame, @hBatAI, @hBatTwo, @hWhiteChess, @hBlackChess, @hFont
;***********************************************************
		invoke	BitBlt, @hdcWindow, 0, 0, 1000, 700, @hdcMemBuffer, 0, 0, SRCCOPY
		
		invoke	DeleteObject, @blankBmp
		invoke	DeleteObject, @hBoard
		invoke	DeleteObject, @hWhiteChess
		invoke	DeleteObject, @hBlackChess
		invoke	DeleteObject, @hPen
		invoke	DeleteObject, @hFont
		invoke	DeleteObject, @hAIGame
		invoke	DeleteObject, @hTwoMenGame
		invoke	DeleteObject, @hBatAI
		invoke	DeleteObject, @hBatTwo

		invoke	DeleteDC,	@hdcMemBuffer
		invoke	DeleteDC,	@hdcLoadBmp
		invoke	EndPaint, hWnd, addr @stPs
;***************************************************
	.elseif eax == WM_LBUTTONUP
	;***********************************
		mov	eax, lParam
		mov	@posX, ax
		sar	eax, 16
		mov	@posY, ax
	;**********************************
		invoke	_RespMouse, hWnd ,@posX, @posY
;*************************************************
	.elseif	eax == WM_CLOSE
		invoke	PostQuitMessage, 0
		invoke	DestroyWindow, hWinMain
	.else
		invoke	DefWindowProc, hWnd, uMsg, wParam, lParam
		ret
	.endif
;*****************************************
	xor	eax, eax
	ret
_ProcWinMain	endp

;>>>>>>>>>>>>>>>>>>>>>>>>>>>
;	������
;>>>>>>>>>>>>>>>>>>>>>>>>>>>
_WinMain	proc
	local	@stWndClass:WNDCLASSEX
	local	@stMsg:MSG
;******************************************
;��ֵ��ʼ��
	mov	dwCurrGame, 0
	invoke	_RestartGame
	invoke	GetModuleHandle, NULL
	mov		hInstance, eax
	invoke	RtlZeroMemory, addr @stWndClass, sizeof @stWndClass
;*******************************************
	invoke	LoadCursor, 0, IDC_ARROW	;�趨���
	mov		@stWndClass.hCursor, eax
	push	hInstance
	pop		@stWndClass.hInstance		;�洢hinstance
	mov		@stWndClass.cbSize, sizeof WNDCLASSEX
	mov     @stWndClass.lpfnWndProc, offset _ProcWinMain
	mov		@stWndClass.lpszClassName, offset szClassName
; Register the window class
	invoke	RegisterClassEx, addr @stWndClass
	.if	eax == 0	; for error 
		call ErrorHandler
		jmp	Exit_Program
	.endif
; Create the application's main window
	invoke	CreateWindowEx, WS_EX_APPWINDOW, offset szClassName, offset szWindowName,\
							WS_POPUP or WS_CAPTION or WS_SYSMENU, 50, 10, 1000, 700,\
							NULL, NULL, hInstance, NULL
	mov		hWinMain, eax
; If CreateWindowEx failed, display a message & exit.
	.if eax == 0
	  call ErrorHandler
	  jmp  Exit_Program
	.endif

	invoke	ShowWindow, hWinMain, SW_SHOWNORMAL
	invoke	UpdateWindow, hWinMain
;*******************��Ϣѭ��**************
	.while	TRUE
		invoke	GetMessage, addr @stMsg, NULL, 0, 0
		.if	eax == 0
			.break	
		.endif
		invoke	TranslateMessage, addr @stMsg
		invoke	DispatchMessage, addr @stMsg
	.endw
;********************�˳�*******************
Exit_Program:
	  INVOKE ExitProcess,0
_WinMain endp

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>
ErrorHandler proc
; Display the appropriate system error message.
;---------------------------------------------------
.data
pErrorMsg  DWORD ?		; ptr to error message
messageID  DWORD ?
.code
	invoke GetLastError	; Returns message ID in EAX
	mov messageID,eax

	; Get the corresponding message string.
	invoke FormatMessage, FORMAT_MESSAGE_ALLOCATE_BUFFER + \
	  FORMAT_MESSAGE_FROM_SYSTEM,NULL,messageID,NULL,
	  addr pErrorMsg,NULL,NULL

	; Display the error message.
	invoke MessageBox,NULL, pErrorMsg, addr ErrorTitle,
	  MB_ICONERROR+MB_OK

	; Free the error message string.
	invoke LocalFree, pErrorMsg
	ret
ErrorHandler endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>
end	_WinMain