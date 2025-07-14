import React from 'react';
import osinfraLogoHome from '../../Root/logo/osinfra-home.png';

const homePageLogoStyles: React.CSSProperties = {
	width: '260px',
	height: 'auto',
	display: 'block',
	margin: '0 auto 8px auto',
};

const HomePageLogo = () => (
	<img src={osinfraLogoHome} style={homePageLogoStyles} alt="Home Logo" />
);

export default HomePageLogo;
