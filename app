import streamlit as st

from src.pipeline import answer_question

st.set_page_config(page_title="Aussie RAG Bot", page_icon="🇦🇺")
st.title("🇦🇺 Aussie Stocks & News RAG Bot")
st.caption("Ask about ASX stocks and recent Australian news.")

if "messages" not in st.session_state:
    st.session_state.messages = []

for msg in st.session_state.messages:
    with st.chat_message(msg["role"]):
        st.markdown(msg["content"])

if prompt := st.chat_input("Ask about an ASX stock or recent news..."):
    st.session_state.messages.append({"role": "user", "content": prompt})
    with st.chat_message("user"):
        st.markdown(prompt)

    with st.chat_message("assistant"):
        with st.spinner("Retrieving and generating..."):
            result = answer_question(prompt)
            st.markdown(result["answer"])

            with st.expander("Sources used"):
                for chunk in result["retrieved_chunks"]:
                    st.json(chunk["metadata"])

    st.session_state.messages.append({"role": "assistant", "content": result["answer"]})

