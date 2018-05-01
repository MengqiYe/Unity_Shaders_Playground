// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "UV/Blur"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_F("F", range(1,30)) = 10
		_A("Amplitude", range(0,0.1)) = 0.01
		_R("Radius", range(0,1)) = 0.1
		_S("Speed", range(0,5)) = 1
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			#pragma target 3.0
			
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
				float z : TEXCOORD1;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;

			float _F;
			float _A;
			float _R;
			float _S;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.z = mul(unity_ObjectToWorld, v.vertex).z;
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// ddx / ddy

				float dx = ddx(i.uv.x) * 10;
				float2 dsdx = float2(dx, dx);

				float dy = ddy(i.uv.y) * 10;
				float2 dsdy = float2(dy, dy);

				float2 dsdz = ddx(i.z) * 10;

				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv, dsdz, dsdz);
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
}
