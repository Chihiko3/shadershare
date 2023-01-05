Shader "Unlit/USB_stencil_ref"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "Queue"="Geometry-1" } // !
        
        ZWrite Off // !
        ColorMask 0 // !
        
        Stencil // !
        {
            Ref 2 // !StencilRef
            Comp Always // !Always pss the Stencil Test
            Pass Replace // !Pass Replace means that the current values of the Sencil Buffer be replaced by the sencilRef Value, in this situation, always = 2
            // 对Replace再做一下解释，摄像机的视野会给所有像素赋一个值放在Stencil Buffer里面，默认是0。
            // 通过这个replace，可以将当前物体所在区域（摄像机视角中）全部赋值为 Ref 的值。也就是将摄像机中透过该物体的所有值的Stencil改写为2。
            
        }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata // input
            {
                float4 vertex : POSITION; // 创建了一个名为vertex的储存vertex的在其自身坐标系中的位置信息
                float2 uv : TEXCOORD0;
            };

            struct v2f // output
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
