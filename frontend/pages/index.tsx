import React from "react";
import Head from "next/head";
import styled from "styled-components";

const HomePage: React.FC = () => {
  return (
    <>
      <Head>
        <title>プロジェクトチャレンジ</title>
        <meta name="description" content="実務未経験のエンジニアがスキルを磨けるプラットフォーム" />
      </Head>
      <_Container>
        <_Title>プロジェクトチャレンジ</_Title>
        <_Subtitle>実務未経験のエンジニアがスキルを磨けるプラットフォーム</_Subtitle>
      </_Container>
    </>
  );
};

export default HomePage;

const _Container = styled.div`
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 100vh;
`;

const _Title = styled.h1`
  font-size: 3rem;
  color: #333;
`;

const _Subtitle = styled.h2`
  font-size: 1.5rem;
  color: #666;
`;