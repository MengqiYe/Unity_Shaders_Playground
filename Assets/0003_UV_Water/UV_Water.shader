Shader "Unlit/UV_Water"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_F("F", range(1,30)) = 10
		_A("Amplitude", range(0,0.1)) = 0.01
		_R("Radius", range(0,1)) = 0.1
		_S("Speed", range(0,5)) = 1
	}
		SubShader
		{
			Tags { "RenderType" = "Opaque" }
			LOD 100

			Pass
			{
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				// make fog work
				#pragma multi_compile_fog

				#include "UnityCG.cginc"

				struct appdata
				{
					float4 vertex : POSITION;
					float2 uv : TEXCOORD0;
				};

				struct v2f
				{
					float2 uv : TEXCOORD0;
					UNITY_FOG_COORDS(1)
					float4 vertex : SV_POSITION;
				};

				sampler2D _MainTex;
				float4 _MainTex_ST;

				float _F;
				float _A;
				float _R;
				float _S;

				float _Pi = 3.14;

				v2f vert(appdata v)
				{
					v2f o;
					o.vertex = UnityObjectToClipPos(v.vertex);
					o.uv = TRANSFORM_TEX(v.uv, _MainTex);
					UNITY_TRANSFER_FOG(o,o.vertex);
					return o;
				}

				fixed4 frag(v2f i) : SV_Target
				{
					// sample the texture

					// i.uv += _Time.x;

					// i.uv.x += _A * sin(i.uv.x *Pi * _F + _Time.y);
					// i.uv.y += _A * sin(i.uv.y *Pi * _F + _Time.y);

					float2 uv = i.uv;
					float dis = distance(uv, float2(0.5, 0.5));

					_A *= saturate(1 - dis / _R);

					float energy = _A * sin(-dis * 3.14 * _F + _Time.y * _S);

					uv += uv * energy;
					fixed4 col = tex2D(_MainTex, uv);
					// col = tex2D(_MainTex, uv) + fixed4(1,1,1,1) * saturate(energy) * 100;
					// apply fog
					UNITY_APPLY_FOG(i.fogCoord, col);
					return col;
				}
				ENDCG
			}
		}
}
