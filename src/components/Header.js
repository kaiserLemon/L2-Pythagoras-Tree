// Import Assets
import profile from '../assets/profile.jpg';

const Header = () => {
    return (
        <section className='header'>
            <img src={profile} alt="Andy Torres" />

            <div className='header__content'>
                <h1>Hi, I'm Andy Torres</h1>
                <p>Blockchain Developer</p>
                <a href="wikipedia.org" className='button'>Get In Touch</a>
            </div>
        </section>
    );
}

export default Header;